# BoardHawk

BoardHawk is an example application that shows off the start of an app that supports Catalyst, and is thus running on both iOS and macOS.

I wanted to do a serious attempt at building an app running on both platforms. While this application is only a start, I think it does show the possibilities of Catalyst.

## Usage

Make sure to set the required environment variables in the scheme:

`GITHUB_CLIENT_ID`: your GitHub client ID
`GITHUB_CLIENT_SECRET`: your GitHub client secret

You can create your own GitHub OAuth application for it [in your application settings](https://github.com/settings/applications/new). The callback URL should be `boardhawk://`.
