class Notifier < ActionMailer::Base
  default from: "Mailgun Test Project <postmaster@" + ENV['MAILGUN_DOMAIN'] + ">"

  def send_email(message)
    @message = message
    mail(to: @message[:to], subject: 'Mailgun message via SMTP')
  end
end
