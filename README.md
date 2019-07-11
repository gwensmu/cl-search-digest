A replacement for IFTTTs defunct "classifieds" feature.

## Local development:

    You'll need to have verified the sender/recipient email addresses via SES,
    and to have configured your shared credentials file if running locally.

    ```
    > $ ruby app/mailer.rb --config drumheads.yml
    ```

## Deployment

``` ./deploy.sh ```