Craigslist removed its RSS feeds, RIP RSS

# What was this

This tool used to search Craigslist using a configured query and send an email digest of the results. It was a replacement for IFTTTs defunct "classifieds" feature. This tool was designed to run as a Lambda in AWS on a cron schedule via EventBridge.

## Local development:

    You'll need to have verified the sender/recipient email addresses via SES,
    and to have configured your shared credentials file if running locally.

    ```
    > $ ruby app/mailer.rb --config drumheads.yml
    ```

## Deployment

``` ./deploy.sh ```
