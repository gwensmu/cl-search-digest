# bundle install
bundle install --without test development --path vendor/bundle

# package zip
zip -r function.zip function.rb lib config views vendor

# push code
aws lambda update-function-code --region us-west-2 --function-name loomSearch --zip-file fileb://function.zip