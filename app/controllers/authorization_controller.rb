# encoding: utf-8
class AuthorizationController < WebsocketRails::BaseController

  # If you want peer to peer messaging or a private single user channel you could follow a scheme where
  # the secure channel name matches their user email and id or something similar
  def authorize_secure_channel
    channel_name = WebsocketRails[message[:channel]]
    id = current_user.id
    email = current_user.email

    if "#{email}-#{id}" == channel_name
      accept_secure_channel
    else
      deny_secure_channel
    end
  end

  # If you want all users to be able to connect but only some to be able to send to the
  # channel then just allow all subscriptions.
  # def authorize_secure_channel
  #   accept_secure_channel
  # end

  ##
  # Authorizing Messages From Clients
  #
  # This method would be called every time a message is sent from a client to a secure channel.
  # If the message is authorized then it will be broadcasted out to the channel. If it is denied
  # then it will silently be dropped or perhaps a message will be sent back to that client saying
  # that their message was declined. 
  ##

  # If you want only a select group of authorized users to be able to broadcast to the channel like
  # def authorize_secure_message
  #   channel_name = WebsocketRails[message[:channel]]

  #   if current_user.role == :author || current_user.can_broadcast_to?(channel_name)
  #     authorize_secure_message
  #   else
  #     deny_secure_message
  #   end
  # end

  # For the peer to peer messaging use case maybe something like...
  def authorize_secure_message
    channel_name = WebsocketRails[message[:channel]]
    broadcast_user = WebsocketRails[message[:user_id]] # The user that sent the message

    if broadcast_user.can_message?(current_user)
      authorize_secure_message
    else
      deny_secure_message
    end
  end

  # If you just want it to be a broadcast channel for feed updates you can deny all client messages
  # def authorize_secure_message
  #   deny_secure_message
  # end

end
