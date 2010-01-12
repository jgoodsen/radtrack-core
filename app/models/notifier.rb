class Notifier < ActionMailer::Base

  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "radtrack administrator"
    recipients    user.email
    sent_on       Time.now
    body          :user => user
  end

end
