# To run the webapp locally:

        bundle exec rackup -p 3000

        http://localhost:3000/drumheads -> uses named config if it exists
        http://localhost:3000/ -> loads default config

# To email yourself

    Install and configure sendmail on your host.

    ```
    > $ ruby app/mailer.rb --config drumheads.yml
    > Delivered an email via sendmail!
    ```

    Or, if you have an AWS account, use AWS SES:

    ```
    # config.yml

    delivery_method: aws_ses
    ```

    You'll need to have verified the sender/recipient email addresses via SES,
    and to have configured your shared credentials file if running locally.
