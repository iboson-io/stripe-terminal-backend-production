# Stripe Terminal Backend

⚠️ **Production Ready**: This backend has been configured for production deployment with authentication, security headers, and proper CORS configuration. See [Production Deployment](#production-deployment) for details.

> **Note**: If you're looking for the original example/testing version, refer to the git history or the original Stripe example repository.

This is a simple [Sinatra](http://www.sinatrarb.com/) webapp that you can use to run the [Stripe Terminal](https://stripe.com/docs/terminal) example apps. To get started, you can choose from the following options:

1. [Run it on a free Render account](#running-on-render)
2. [Run it on Heroku](#running-on-heroku)
3. [Run it locally on your machine](#running-locally-on-your-machine)
4. [Run it locally via Docker CLI](#running-locally-with-docker)

ℹ️  You also need to obtain your Stripe **secret** API Key (test mode for development, live mode for production), available in the [Dashboard](https://dashboard.stripe.com/account/apikeys). Note that you must use your secret key, not your publishable key, to set up the backend. For more information on the differences between **secret** and publishable keys, see [API Keys](https://stripe.com/docs/keys). For more information on **test and live modes**, see [Test and live modes](https://stripe.com/docs/keys#test-live-modes).

## Running the app

### Running locally on your machine

If you prefer running the backend locally, ensure you have the required [Ruby runtime](https://www.ruby-lang.org/en/documentation/installation/) version installed as per the [latest Gemfile in this repo](Gemfile).

You'll also need the correct [Bundler](https://bundler.io/) version, outlined in the [Gemfile.lock](Gemfile.lock) under the `BUNDLED_WITH` directive.

Clone down this repo to your computer, and then follow the steps below:

1. Create a file named `.env` within the newly cloned repo directory and add the following lines:
```
# For local development (test mode)
STRIPE_TEST_SECRET_KEY=sk_test_YOUR_TEST_KEY
ENVIRONMENT=development
STRIPE_ENV=test

# Optional: Add API key for local testing (recommended)
# API_KEY=your-local-test-api-key

# Optional: Restrict CORS origins for local development
# ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

   **Note**: For production, see the [Production Deployment](#production-deployment) section.

2. In your terminal, run `bundle install`
3. Run `ruby web.rb`
4. The example backend should now be running at `http://localhost:4567`
5. Go to the [next steps](#next-steps) in this README for how to use this app

### Running locally with Docker

We have a pre-built Docker image you can run locally if you're into the convenience of containers.

 Install [Docker Desktop](https://www.docker.com/products/docker-desktop) if you don't already have it. Then follow the steps below:

1. In your terminal, run `docker run -e STRIPE_TEST_SECRET_KEY={YOUR_API_KEY} -p 4567:4567 stripe/example-terminal-backend` (replace `{YOUR_API_KEY}` with your own test key)
2. The example backend should now be running at `http://localhost:4567`
3. Go to the [next steps](#next-steps) in this README for how to use this app

### Running on Render

1. Set up a free [render account](https://dashboard.render.com/register).
2. Click the button below to deploy the example backend. You'll be prompted to enter a name for the Render service group as well as your Stripe API key.
3. Go to the [next steps](#next-steps) in this README for how to use this app

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/stripe/example-terminal-backend/)

### Running on Heroku

1. Set up a [Heroku account](https://signup.heroku.com).
2. Click the button below to deploy the example backend. You'll be prompted to enter a name for the Heroku application as well as your Stripe API key.
3. Go to the [next steps](#next-steps) in this README for how to use this app

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/stripe/example-terminal-backend)

---

## Production Deployment

### ⚠️ Important Security Considerations

This backend has been configured for production use with the following security features:

- **API Authentication**: All endpoints (except `/`) require authentication via API key
- **CORS Protection**: Configurable allowed origins to prevent unauthorized access
- **Security Headers**: XSS protection, frame options, content type sniffing protection
- **Production Stripe Keys**: Support for live mode Stripe API keys
- **Environment Detection**: Automatic detection of production vs test mode

### Required Environment Variables

For production deployment, you **must** configure the following environment variables:

1. **`API_KEY`** (REQUIRED): A strong, randomly generated API key for authenticating requests
   - Generate a secure key: `openssl rand -hex 32` or use a password manager
   - Clients must send this key in the `X-API-Key` header or `Authorization: Bearer <key>` header

2. **`STRIPE_SECRET_KEY`** (REQUIRED for production): Your Stripe **live** secret key (starts with `sk_live_...`)
   - Get it from: https://dashboard.stripe.com/account/apikeys
   - **Never commit this key to version control**

3. **`ALLOWED_ORIGINS`** (REQUIRED for production): Comma-separated list of allowed CORS origins
   - Example: `https://yourdomain.com,https://app.yourdomain.com`
   - **Do not use `*` in production** - specify exact origins

4. **`ENVIRONMENT`** or **`RACK_ENV`**: Set to `production` to enable production mode

5. **`STRIPE_ENV`**: Set to `production` to use live Stripe keys (defaults based on ENVIRONMENT)

### Optional Environment Variables

- **`STRIPE_TEST_SECRET_KEY`**: Your test Stripe key (for development/testing)
- **`PORT`**: Port to run the server on (usually set automatically by hosting platform)

### Production Deployment Steps

#### Option 1: Render.com

1. Fork or deploy this repository to Render
2. In your Render dashboard, go to Environment Variables
3. Set the required variables:
   ```
   ENVIRONMENT=production
   STRIPE_ENV=production
   RACK_ENV=production
   STRIPE_SECRET_KEY=sk_live_...
   API_KEY=<generate-a-strong-random-key>
   ALLOWED_ORIGINS=https://yourdomain.com,https://app.yourdomain.com
   ```
4. Deploy the service

#### Option 2: Heroku

1. Create a new Heroku app: `heroku create your-app-name`
2. Set environment variables:
   ```bash
   heroku config:set ENVIRONMENT=production
   heroku config:set STRIPE_ENV=production
   heroku config:set RACK_ENV=production
   heroku config:set STRIPE_SECRET_KEY=sk_live_...
   heroku config:set API_KEY=<generate-a-strong-random-key>
   heroku config:set ALLOWED_ORIGINS=https://yourdomain.com
   ```
3. Deploy: `git push heroku main`

#### Option 3: Docker

1. Build the image:
   ```bash
   docker build -t stripe-terminal-backend .
   ```

2. Run with environment variables:
   ```bash
   docker run -d \
     -p 4567:4567 \
     -e ENVIRONMENT=production \
     -e STRIPE_ENV=production \
     -e STRIPE_SECRET_KEY=sk_live_... \
     -e API_KEY=<your-api-key> \
     -e ALLOWED_ORIGINS=https://yourdomain.com \
     stripe-terminal-backend
   ```

### Client Integration

When calling the API from your frontend or mobile app, include the API key in requests:

**Using X-API-Key header:**
```javascript
fetch('https://your-backend.com/connection_token', {
  method: 'POST',
  headers: {
    'X-API-Key': 'your-api-key',
    'Content-Type': 'application/json'
  }
})
```

**Using Authorization header:**
```javascript
fetch('https://your-backend.com/connection_token', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer your-api-key',
    'Content-Type': 'application/json'
  }
})
```

### Verification Checklist

Before deploying to production, ensure:

- [ ] `API_KEY` is set and is a strong, random value
- [ ] `STRIPE_SECRET_KEY` is your **live** key (starts with `sk_live_...`)
- [ ] `ALLOWED_ORIGINS` is set and does NOT contain `*`
- [ ] `ENVIRONMENT=production` or `RACK_ENV=production` is set
- [ ] All sensitive keys are stored securely (environment variables, not in code)
- [ ] HTTPS is enabled (handled by your hosting provider)
- [ ] You've tested the endpoints with authentication
- [ ] You've verified CORS is working correctly

### Security Notes

- **Never commit API keys or secrets to version control**
- **Use HTTPS in production** (most hosting platforms provide this automatically)
- **Rotate your API keys regularly** and update them in your environment variables
- **Monitor your Stripe dashboard** for unusual activity
- **Consider implementing rate limiting** at your hosting provider level
- **Keep dependencies updated** for security patches

---

## Next steps

Next, navigate to one of our example apps. Follow the instructions in the README to set up and run the app. You'll provide the URL of the example backend you just deployed.

| SDK | Example App |
|  :---  |  :---  |
| iOS | https://github.com/stripe/stripe-terminal-ios |
| JavaScript | https://github.com/stripe/stripe-terminal-js-demo |
| Android | https://github.com/stripe/stripe-terminal-android |



