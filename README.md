# TAA Logistics Server

## Specifications

The TAA Logistics Server is a Ruby on Rails application designed to manage logistics operations for TAA. It uses PostgreSQL for data storage. This serves as an API for the React Client as well.

### Requirements

- Ruby 2.7.0 or later
- Rails 6.0.0 or later
- PostgreSQL 12.0 or later

## Deployment Notes

Before deploying the TAA Logistics Server, please ensure the following:

1. **SMTP Mailer**: Setup SMTP in production.rb
2. **Configure CSRF**: Make sure only the main domain can make requests to the API
