# salesforce2slack
Simple API for posting messages from Salesforce to Slack

Unmanaged package install link: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t36000000yNjp

## Installation
* Install package to sandbox/dev org using the installation link above.
* Add a Remote Site Setting for 'https://hooks.slack.com' (Settings -> Security Controls -> Remote Site Settings) 
* Add a Slack team along with it's webhook url to the new Slack Team object


## Use
The package provides an APEX method that can be used from Process Builder or Flows.  Options for each message are:
* Team - The Slack team that you want to post to.  This must be configured in the Slack Team object. (required)
* Channel - The Channel that you want to post to. (required)
* Message - The message to post. (required)
* Username - The sender name that you want to appear on the post.  This defaults to the running user full name if it's not set to something else. (optional)
* Icon Emoji - The emoji you want to appear on the post.  You can use any of the Slack emoji's here.  It defaults to ':cloud:' if not set. (optional)
* Ignore Flood Protection - To avoid flooding the Slack channel in the case of an event that triggers your process in bulk, the package enforces a 3 message per execution context limit.  You can override this by setting the Ignore Flood Protection flag to true.
