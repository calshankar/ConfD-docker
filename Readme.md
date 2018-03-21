# Docker Demo Application

This is a Go demo application used for demonstrating confd config management capability. You can check the [Confd
documentation](https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md) which provides 
additional support of Config Management back-end of your choice

Confd, is a simple and reusable approach that relies on Go templates to define templates for your configuration files, and then runs a Go template generator to render an 
environment-specific version of your configuration file template to a configurable location.

Check out my [demo](https://youtu.be/eLVBg3Ibet0) with sample implementation which describes the simple & easy way to set it up. 

## Environment Variables used by the Go App

- `TITLE`: sets title in demo app
- `SHOW_VERSION`: show version of app in ui (`VERSION` env var)
- `REFRESH_INTERVAL`: interval in milliseconds for page to refresh (default: 1000)
- `SKIP_ERRORS`: set this to prevent errors from counting (useful on janky load balancers)
- `METADATA`: extra text at bottom of info area

## Build

docker image build . --tag "image_name:<your custom tag>"

## Run

docker run -P --rm image_name:<your custom tag>
