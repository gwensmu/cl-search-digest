require "aws-sdk"
require_relative "notifier"

class AwsNotifier < Notifier
  def deliver(client: nil)
    begin
      # todo: pull region from config
      client ||= Aws::SES::Client.new(region: 'us-west-2')
      client.send_email({
        destination: {
          to_addresses: [@recipient],
        },
        message: {
          body: {
            html: {
              charset: "UTF-8",
              data: @body_html
            },
          },
          subject: {
            charset: "UTF-8",
            data: @subject_text,
          },
        },
        reply_to_addresses: [@sender],
        source: @sender
      })
    rescue Aws::SES::Errors::ServiceError => error
      puts "Email not sent. Error message: #{error}"
    end 
  end
end
