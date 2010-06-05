class Notifier < ActionMailer::Base

  def password_reset_instructions(user)
    subject       "RAD/Track Password Reset Instructions"
    from          "RAD/Track"
    recipients    user.email
    sent_on       Time.now
    body          :user => user
  end

  def project_invitation(user, project, from_user)
    subject       "RAD/Track Project Invitation"
    from          "RAD/Track"
    recipients    user.email
    sent_on       Time.now
    body          :user => user, :project => project, :from_user => from_user
  end

  def added_to_project_notification(user, project, from_user)
    subject       "RAD/Track Project Invitation"
    from          "RAD/Track"
    recipients    user.email
    sent_on       Time.now
    body          :user => user, :project => project, :from_user => from_user
  end
  
end
