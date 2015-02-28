class MailerAlerts < ApplicationMailer
	 default from: 'telebrandsindia@tec2grow.in'
 
  def welcome_email(user)
    @user = user
    @url  = 'http://telebrandsindia.com/'
    mail(to: @user.email, subject: 'Welcome to Sure CRM')
  end

  def dealer_enquiry(emailid, customer, description)
    @customer = customer
   @description = description
    
    
    mail(to: emailid,
         subject: "New Dealer Enquiry")

    
  end
end
