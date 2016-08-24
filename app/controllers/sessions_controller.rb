# encoding: utf-8
class SessionsController < Devise::SessionsController
  layout "blank"
  skip_before_filter :check_setup, [:destroy]
  #before_filter :get_dst

  require 'base64'
  require 'cgi'
  require 'hmac-sha1'
  require 'net/http'
  $entrypoint = 'http://api.xmltime.com/'
  $accesskey = 'X7MzHccMsg'
  $secretkey = 'o9OYEGb8BQ6KozZC26wp'

  def servicecall(service, args)
    timestamp = Time.now.getutc.strftime('%FT%T')
    message = $accesskey + service + timestamp
    digest = HMAC::SHA1.digest($secretkey, message)

    args['accesskey'] = $accesskey
    args['timestamp'] = timestamp
    args['signature'] = Base64.encode64(digest).chomp

    query = args.collect do |key, value|
        [key.to_s, CGI::escape(value.to_s)].join('=')
    end.join(';')

    url = $entrypoint + '/' + service + '?' + query
    Net::HTTP.get(URI.parse(url))
  end

  def get_dst
    timedata = servicecall('dstlist', { 'country'=>'no', 'out'=>'js' })
    all_data= JSON.parse(timedata)
    raise all_data.inspect
    time = ""
    offset = all_data["dstlist"][0]["dsttimezone"]["offset"]
    if offset.present?
      time = 'UTC' + utc_time
    end
    
  end


  
  def destroy
    user = current_user
    user.online_status = false
    user.save
    super
  end
  
  def create
    self.resource = warden.authenticate!(auth_options)
    # if self.resource.pin.present?
    #   if params[:user][:pin] != self.resource.pin
    #     reset_session
    #     flash[:notice] = "Please confirm your pin before login"
    #     respond_with resource, location: new_user_session_path
    #     return
    #   end
    # end
    if self.resource.suspend == true
      reset_session
      flash[:notice] = "Your account has been suspended, Please contact from account admin."
      respond_with resource, location: new_user_session_path
      return
    end
    if self.resource.account.roleable_type == "Personal"

      if self.resource.sign_in_count > 1
        updated_time, utc_offset = time_zone_diff(self.resource)
        notice_msg = "Welcome back #{self.resource.name} Last time logged 
        in: #{updated_time.strftime('%I:%M %p, %d %B')} (#{utc_offset})"
      else
        notice_msg = "Welcome #{self.resource.name}! First time 
        logged into this account!"
      end
    elsif self.resource.account.roleable_type == "Business"
      #raise time_zone_diff(self.resource)[0].strftime('%I:%M %p, %d %B').inspect
     #user = self.resource.account.users.where("last_sign_in_at is not ?", nil).order('last_sign_in_at desc').limit(1).offset(1).first
      user_id = self.resource.account.last_sign_in
      last_id = nil
      if user_id.present?
        last_id = user_id
        self.resource.account.update_column(:last_sign_in, current_user.id)
      else
        self.resource.account.update_column(:last_sign_in, current_user.id)
      end
      user = User.find_by_id(last_id)
      
      if user.present?
        welcome_msg = (user.sign_in_count > 1) ? "Welcome back" : "Welcome"
        if user.id == current_user.id 
          update_time, utc_offset = time_zone_diff(user)
          
          notice_msg = "#{welcome_msg} #{user.name}! Last User to have logged into the Account: #{user.name} at
         : #{update_time.strftime('%I:%M %p, %d %B')} (#{utc_offset})"
        else
          update_time, utc_offset = time_zone_diff(self.resource)
          notice_msg = "#{welcome_msg} #{self.resource.name}! Last User to have logged into the Account: #{user.name} at
         : #{update_time.strftime('%I:%M %p, %d %B')} (#{utc_offset})"
        end
      else
        notice_msg = "Welcome #{self.resource.name}! First time 
        logged into this Account!"
       end
    end

    #set_flash_message(:notice, notice_msg) 
    flash[:notice] = notice_msg
    sign_in(resource_name, resource)
    resource.online_status = true
    resource.save    
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
  def time_zone_diff(user)

    if user.account.time_zone.present?
      Time.zone = user.account.time_zone
      zone = Time.zone
    else
      zone = Time.zone
    end
    
    time_date = Array.new
    #timedata = servicecall('dstlist', { 'country'=>user.country, 'out'=>'js' })
    all_data = {} #JSON.parse(timedata)
    time = ""
    if all_data["dstlist"].present?
      offset = all_data["dstlist"][0]["dsttimezone"]["offset"]
      if offset.present?
        if offset[0] == "+"
          time  = offset[1..-1].to_time
          hr = time.hour
          min = time.min
          time_date [0] =  user.last_sign_in_at + hr*60*60 + min*60
          time_date[1]  = "UTC #{offset}"
        else
          time  = offset[1..-1].to_time
          hr = time.hour
          min = time.min
          time_date [0] =  user.last_sign_in_at - hr*60*60 - min*60
          time_date[1] =  "UTC #{offset}"
        end
      else
        time_date[0] = user.last_sign_in_at
        time_date[1] = (zone.utc_offset == 0) ? 'UTC' : (zone.utc_offset < 0) ? 'UTC'+ sec_hr_min(zone.utc_offset) : 'UTC+'+sec_hr_min(zone.utc_offset)
      end
    else
      time_date[0] = user.last_sign_in_at
      time_date[1] = (zone.utc_offset == 0) ? 'UTC' : (zone.utc_offset < 0) ? 'UTC'+ sec_hr_min(zone.utc_offset) : 'UTC+'+sec_hr_min(zone.utc_offset)

    end
    time_date
    #raise time_date[0].inspect
    # diff = ""
    # t1 = Time.zone.now.in_time_zone("UTC")
    # if current_user.account.time_zone.present?
    #   t2 = Time.zone.now.in_time_zone(current_user.account.time_zone)
    # else
    #   t2 = Time.zone.now
    # end
    # t3 = ((t1.utc_offset - t2.utc_offset)).abs
    # hr = (t3 / 3600).to_i
    # min = (t3/60 - hr * 60).to_i
    # min = min < 10 ? "0#{min}" : min
    # diff = "UTC+ #{hr.to_s} : #{min}"  if t3
    # diff
    
  end

  def sec_hr_min(seconds)
    hours = seconds / 3600 
    seconds -= hours * 3600 
    minutes = seconds / 60
    ("%.2d" % hours.to_s) +":"+ ("%.2d" % minutes.to_s)
  end
  
end
