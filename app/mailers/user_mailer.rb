class UserMailer < ApplicationMailer
  def send_email(user_id, message)
    user = User.find(user_id)
    @message = message
    mail(to: user.email, subject: t(:notification_coldmail))
  end
end
