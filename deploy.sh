bundle install --without test development --path vendor/bundle

rm function.zip
zip -r function.zip function.rb lib config views vendor

aws lambda update-function-code --region us-west-2 --function-name loomSearch --zip-file fileb://function.zip

# todo: a provision.sh file that creates function, role, policy, event handler