# TAA Logistics Server and CRM

## Specifications

The TAA Logistics Server is a Ruby on Rails application designed to manage logistics operations for TAA. It uses PostgreSQL for data storage. This serves as an API for the React Client as well.

### Requirements

- Ruby 2.7.0 or later
- Rails 6.0.0 or later
- PostgreSQL 12.0 or later

## Services

| name | description | env | price |
| ---  |   -----     | --- | ---   |
| **POSTMARK** | Used for sending emails | POSTMARK_API_TOKEN, MAILER_EMAIL| $0-$15 |
| **CLOUDINARY** | Used for image storage | CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET | free |
| **RENDER** | Used for hosting | ADMIN_PASSWORD, CORS_ORIGIN | $12 |
| **TWILIO** | Used for SMS | TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN | undefined |