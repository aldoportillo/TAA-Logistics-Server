class QuoteMailer < ApplicationMailer
    default from: 'notifications@example.com'
  
    def new_quote_email(quote)
      @quote = quote
      mail(to: 'aldoportillodev@gmail.com', subject: 'New Quote Received')
    end
  end
  