class QuoteMailer < ApplicationMailer
    default from: 'aporti4@uillinois.edu'
  
    def new_quote_email(quote)
      @quote = quote
      mail(to: 'aporti4@uillinois.edu', subject: 'New Quote Received')
    end
  end
  