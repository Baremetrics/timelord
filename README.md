# CatBot

## Overview

CatBot is a lightweight Sinatra app that provides [Slack](http://slack.com/) with a simple bot for fetching individual cat images from [The Cat API](http://thecatapi.com/). Once setup, you can type `#cat` in your Slack channel and CatBot will post a random gif from The Cat API back to the channel.

CatBot was originally forked from @schuyler's [gifbot](https://github.com/schuyler/gifbot) before I hacked it up and replaced most of the bits with code from [Descartes'](https://github.com/obfuscurity/descartes) [CAT_MODE handler](https://github.com/obfuscurity/descartes/blob/a13dc9a720dab33e0a8d5e8670bd30f93e0bfdba/lib/descartes/routes/cats.rb).

## Usage

### Preparation

CatBot uses a Slack [Outgoing WebHooks](https://slack.com/services/new/outgoing-webhook) integration for catching the `#cat` request and firing it to your CatBot service. You'll need to [add a new Outgoing WebHook](https://slack.com/services/new/outgoing-webhook) first so you'll have the `SLACK_TOKEN` available for the actual CatBot deployment steps below.

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

Once your CatBot application has been deployed you'll need to go back to your Outgoing Webhook page and update the Integration Settings. Generally speaking you'll want to use settings like these (adjust as necessary):

* Channel: `Any`
* Trigger Word: `#cat`
* URL: `http://slack-catbot-123.herokuapp.com/cat` (the `/cat` endpoint is mandatory)
* Label: `catbot`

## License

CatBot is distributed under the MIT license.
