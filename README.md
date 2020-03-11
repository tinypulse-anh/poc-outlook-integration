# Prerequisites

- Setup an Azure AD app with `Calendars.Read` permission.
- Set redirect URL to `http://<you server address>/auth/microsoft_graph/callback`.
- Create a client secret for the app.

# Setup

```
bundle install
bundle exec rake db:setup
```

# Environment

Prepare configurations and put these into `.env.development`:

```
AZURE_APP_ID=<Azure AD app ID>
AZURE_APP_SECRET=<Azure AD app client secret>
AZURE_APP_SCOPES="openid profile email offline_access user.read calendars.read"
CHANGE_NOTIFICATION_ENDPOINT=http://<your server address>
```

# Run

```
bundle exec rails server -b 0.0.0.0
```
