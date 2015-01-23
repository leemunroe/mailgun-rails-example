class HomeController < ApplicationController
  def index
  end

  def create

    # Get message value from form
    @message = params





    # Check if SMTP
    if @message[:mode] == "SMTP"

      # Tell notifier action mailer to send via SMTP
      Notifier.send_email(@message).deliver

      # Redirect on success
      redirect_to root_path, notice: 'Message was sent via SMTP.'




    # Else send via API
    else

      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']

      # Define your message parameters
      html_output = render_to_string template: "notifier/send_email"
      message_params = {:from    => 'Mailgun Test Project <postmaster@' + ENV['MAILGUN_DOMAIN'] + ">",
                        :to      => @message[:to],
                        :subject => 'Mailgun message via API',
                        :text    => @message[:body],
                        :html    => html_output.to_str,
                        "o:tag"  => 'test'}

      # Send your message through the client
      mg_client.send_message ENV['MAILGUN_DOMAIN'], message_params

      # Redirect on success
      redirect_to root_path, notice: 'Message was sent via API.'
    end
  end
end
