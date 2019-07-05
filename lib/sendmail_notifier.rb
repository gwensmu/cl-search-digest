require "mail"
require_relative "notifier"

class SendmailNotifier < Notifier
  def deliver
    mail = Mail.new do
      from    @sender
      to      @recipient
      subject @subject_text
      html_part do
        content_type "text/html; charset=UTF-8"
        body @body_html
      end
    end
    mail.delivery_method :sendmail
    mail.deliver
    mail
  end
end
