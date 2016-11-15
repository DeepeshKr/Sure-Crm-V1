class CreditCard #< ActiveRecord::Base
  # before_validation :set_type
 #  validates :number, presence:true, length: { is: 6}
 #  validate :check_luhn
#Methods for luhn validation

#First checking the type of card
    def self.find_type(credit_card)
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

#Secondly applying the Luhn algorithm on the number to check is the number valid or not
def self.luhn(cc_number)
  code = cc_number
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
      "valid"
    else
      "invalid"
    end
    
  end

end