# TimeLord by [Baremetrics](https://baremetrics.com)
_[Baremetrics](https://baremetrics.com) provides one-click analytics & insights for Stripe. **[Get started today!](https://baremetrics.com)**_

## Overview

TimeLord is a lightweight Sinatra app that provides [Slack](http://slack.com/). Once setup, you can type `#e,#p,#m,or #c` in your Slack channel and TimeLord will post the time in various time zones.

At [Baremetrics](https://baremetrics.com), we're a distributed team (spanning six different timezones) so when we mention various times in Slack, it can get confusing about what time that means for each person. TimeLord solves that.

![TimeLord Example](https://s3.amazonaws.com/f.cl.ly/items/0g1G0u2B2e000e3m0P1s/timelord.png)

## Usage

### Preparation

TimeLord uses a Slack [Outgoing WebHooks](https://slack.com/services/new/outgoing-webhook) integration for catching the `#e,#p,#m,or #c` request and firing it to your TimeLord service. You'll need to [add a new Outgoing WebHook](https://slack.com/services/new/outgoing-webhook) first so you'll have the `SLACK_TOKEN` available for the actual TimeLord deployment steps below.

### Deployment

#### Local

```
$ bundle install
$ export SLACK_TOKEN=...
$ foreman start
```

#### Heroku

```
$ heroku create
$ heroku config:set SLACK_TOKEN=...
$ git push heroku master
```

### WebHook Settings

Once your TimeLord applitimeion has been deployed you'll need to go back to your Outgoing Webhook page and update the Integration Settings. Generally speaking you'll want to use settings like these (adjust as necessary):

* Channel: `Any`
* Trigger Word: `#time`
* URL: `http://slack-TimeLord-123.herokuapp.com/time` (the `/time` endpoint is mandatory)
* Label: `TimeLord`

