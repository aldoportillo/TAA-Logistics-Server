class QuoteMailer < ApplicationMailer
    default from: ENV[MAILER_EMAIL]
  
    def new_quote_email(quote)
      @quote = quote
      mail(to: ENV[MAILER_EMAIL], subject: 'New Quote Received')
    end
  end
  