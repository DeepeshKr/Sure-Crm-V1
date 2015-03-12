class CorporateorderController < ApplicationController
  before_action :set_corporate, only: [:show, :create, :products, :addproducts,
   :payment, :addpayment, :review]

  respond_to :html
  def list
    #list of corporates who have recently ordere but not completed!
    #list all open orders

  end

  def new
    #start creating new order here

  end

  def create
    #this is post command to create new order for date

  end

  def products
    #show all the products added

  end

  def addproducts
    #show all the products added

  end

  def payment
    #show the payment mode and details of payment to be made


  end

  def addpayment
    #post
    #show the payment mode and details of payment to be made


  end

  def review


  end

  def process
    #post
    #close the order

  end

  def summary


  end

  private
    def set_corporate
      @corporate = Corporate.find(params[:id])
    end

    def corporate_params
      params.require(:corporate)
      .permit(:name, :address1, :address2, :address3, 
        :landmark, :city, :pincode, :state, :district, 
        :country, :telephone1, :telephone2, :fax, 
        :website, :salute1, :first_name1, :last_name1, 
        :designation1, :mobile1, :emaild1, :salute2, 
        :first_name2, :last_name2, :designation2, 
        :mobile2, :emailid2, :salute3, :first_name3, 
        :last_name3, :designation3, :mobile3, 
        :emailid3, :description)
    end
end
