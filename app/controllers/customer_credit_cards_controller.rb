class CustomerCreditCardsController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_customer_credit_card, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @customer_credit_cards = CustomerCreditCard.all
    respond_with(@customer_credit_cards)
  end

  def show
    respond_with(@customer_credit_card)
  end

  def new
    @customer_credit_card = CustomerCreditCard.new
    respond_with(@customer_credit_card)
  end

  def edit
  end

  def create
    @customer_credit_card = CustomerCreditCard.new(customer_credit_card_params)
    @customer_credit_card.save
    respond_with(@customer_credit_card)
  end

  def update
    @customer_credit_card.update(customer_credit_card_params)
    respond_with(@customer_credit_card)
  end

  def destroy
    @customer_credit_card.destroy
    respond_with(@customer_credit_card)
  end

  def luhn
    code = params[:code]
    s1 = s2 = 0
    code.to_s.reverse.chars.each_slice(2) do |odd, even| 
    s1 += odd.to_i
 
    double = even.to_i * 2
    double -= 9 if double >= 10
    s2 += double
    end
    p = (s1 + s2) % 10 == 0
    @cardno = code
    
    if (s1 + s2) % 10 == 0
      @card_type = card_type(code) 
      @color = "green"
      @valid = "is a Valid "
    else
      @card_type = " " 
      @color = "red"
      @valid = "is an In-Valid "
    end
 
  end

  private
    def card_type(credit_card)
        # Making sure that the card number is passed as a string
        credit_card = credit_card.to_s
        # Set of statements to return the appropriate card type
        # Firstly the code checks the cards's length
        # Secondly regexp, returns 0 which signals validation
        #return "AMEX"   if credit_card.length == 15 && (credit_card =~ /^(34|37)/) == 0
        return "Discover"   if credit_card.length == 16 && (credit_card =~ /^6011/) == 0
        return "MasterCard" if credit_card.length == 16 && (credit_card =~ /^(5[1-5])/) == 0
        return "VISA"   if [13,16].include?(credit_card.length) && (credit_card =~ /^4/) == 0
        return "Unknown"
    end

    def set_customer_credit_card
      @customer_credit_card = CustomerCreditCard.find(params[:id])
    end

    def customer_credit_card_params
      params.require(:customer_credit_card).permit(:customer_id, :card_no, :name_on_card, :expiry_mon, :expiry_yr_string)
    end
end
