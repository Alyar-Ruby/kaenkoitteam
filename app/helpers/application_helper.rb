module ApplicationHelper
  
	def country_name(alpha2)
    if alpha2.present?
      country = Country.find_country_by_alpha2(alpha2)
      country ? country.name : nil
    else
      ""
    end
  end

  def state_name(country, state)
    if country.present?

      ct = Country.find_country_by_alpha2(country)
      if ct and state.present?
        (ct.states && ct.states[state].present?) ? ct.states[state]["name"] : nil
      end
    else
      ""
    end

  end

  def notification_count
    if current_user.to_notifications.where("checked =?", false).count > 0
      '<span class="badge pull-right" id="notify_circle_size">'+current_user.to_notifications.where("checked =?", false).count.to_s+'</span>'
    else
      ''
    end
  end

  def relative_time(start_time)
    time = "#{time_ago_in_words(start_time)} ago".gsub('about', "")
    month = time.include?("months")
    if month == false
		  case time
		  	when "less than a minute ago"
		  	 time = "Just now"
		  	when "1 day ago"
		  		time = "Yesterday #{start_time.strftime('%I:%M %p')}"
		  	else
		  		time
		  end
		else
			time = start_time.strftime("%d %h")
    end
    year = time.include?("year")
    year == true ? start_time.strftime("%d %h %Y") : time
  end
  
  def time_zone_diff
    if current_user.account.time_zone.present?
      Time.zone = current_user.account.time_zone
      zone = Time.zone
    else
      zone = Time.zone
    end
  	# diff = ""
  	# t1 = Time.zone.now.in_time_zone("UTC")
  	# if current_user.account.time_zone.present?
  	# 	t2 = Time.zone.now.in_time_zone(current_user.account.time_zone)
  	# else
  	# 	t2 = Time.zone.now
  	# end
  	# t3 = ((t1.utc_offset - t2.utc_offset)).abs
  	# hr = (t3 / 3600).to_i
  	# min = (t3/60 - hr * 60).to_i
  	# min = min < 10 ? "0#{min}" : min
  	# diff = "UTC+ #{hr.to_s} : #{min}"  if t3
  	# diff
    (zone.utc_offset == 0) ? '(UTC)' : (zone.utc_offset < 0) ? '(UTC'+sec_hr_min(zone.utc_offset)+') '+zone.name : '(UTC+'+sec_hr_min(zone.utc_offset)+') '+ zone.name
  end

  def sec_hr_min(seconds)
    hours = seconds / 3600 
    seconds -= hours * 3600 
    minutes = seconds / 60
    ("%.2d" % hours.to_s) +":"+ ("%.2d" % minutes.to_s)
  end

  def trans_status(status)
    sclass = "label"
    case status
      when "Pending"
        sclass += " " + "label-warning"
      when "Completed"
        sclass += " " + "label-success"
      when "Cancelled"
         sclass += " " + "label-danger" 
      when "Refunded"
          sclass += " " + "label-warning" 
      else
        ""
    end

  end


end 
