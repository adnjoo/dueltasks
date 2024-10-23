# DuelTasks Credentials Setup

To run DuelTasks, configure `credentials.yml.enc` with the following keys for services like AWS, Stripe, and Mailgun, as well as the `secret_key_base` for Rails security.

### Local Environment

Use this command to edit credentials locally:

```bash
VISUAL="code --wait" bin/rails credentials:edit
```

### Production Environment

For production credentials, use:

```bash
VISUAL="code --wait" bin/rails credentials:edit -e production
```

### Required Credentials

```yaml
secret_key_base: YOUR_RAILS_SECRET_KEY_BASE

stripe:
  secret_key: YOUR_STRIPE_SECRET_KEY
  publishable_key: YOUR_STRIPE_PUBLISHABLE_KEY
  pricing:
    monthly: YOUR_STRIPE_MONTHLY_PRICE_ID

mailgun:
  api_key: YOUR_MAILGUN_API_KEY
  domain: YOUR_MAILGUN_DOMAIN
```

Ensure these keys are added securely, and follow Rails best practices for encryption.
