class QuoteMailer < ApplicationMailer
    default from: 'ed@taalogistics.com'
  
    def new_quote_email(quote)
      @quote = quote
      mail(to: 'ed@taalogistics.com', subject: 'New Quote Received')
    end
  end
  