class IndiaPincodeList < ActiveRecord::Base
	require 'csv'

def location
	self.pincode + " " + self.taluk + " " + self.districtname
end
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|

      pincode_hash = row.to_hash # exclude the price field
      pincode_list = IndiaPincodeList.where(pincode: pincode_hash["pincode"])

      #if pincode_list.count == 1
      	#add execption
      	#product.first.update_attributes(product_hash.except("price"))

       # pincode_list.first.update_attributes(pincode_hash)
      #else
        IndiaPincodeList.create(pincode: pincode_hash["pincode"], officename: pincode_hash["officename"], 
        	deliverystatus:  pincode_hash["deliverystatus"], divisionname:  pincode_hash["divisionname"], 
        	regionname:  pincode_hash["regionname"], circlename:  pincode_hash["circlename"], 
        	taluk:  pincode_hash["taluk"],
        	districtname:  pincode_hash["districtname"], statename:  pincode_hash["statename"])
      #end # end if !pincode_list.nil?
    end # end CSV.foreach
  end # end self.import(file)
  
  def self.check_for_changed_state statename, pincode
    base_url = "https://data.gov.in/api/datastore/resource.json"
    resource_id_1 = "0a076478-3fd3-4e2c-b2d2-581876f56d77" # All India Pincode Directory along with Contact Details
    resource_id_2 = "7eca2fa3-d6f5-444e-b3d6-faa441e35294" # All Locality Search
    resource_id_3 = "6176ee09-3d56-4a3b-8115-21841576b2f6" # All India Pincode Directory no telegana details found
    resource_id_4 = "04cbe4b1-2f2b-4c39-a1d5-1c2e28bc0e32" # All India Pincode directory with contact details along with Latitude and longitude
    api_key = "642f4b9bfbc00aa76834551930785f93"
    
    limit=100
    # Localitydetail1
    if statename.present?
      filters = "filters[statename]=#{statename}"
    end
    if pincode.present?
      filters = "filters[pincode]=#{pincode}"
    end
    
    api_url = "#{base_url}?resource_id=#{resource_id_1}&api-key=#{api_key}&#{filters}" 
  
    uri = URI(api_url)
    jsonArray = Net::HTTP.get(uri)
    #JSON.parse(response)
    #@india_pincode_lists = JSON.parse(jsonArray)
     JSON.parse(jsonArray)
  end
  
  def update_local_db_with_changed_state statename
    
    base_url = "https://data.gov.in/api/datastore/resource.json"
    resource_id_1 = "0a076478-3fd3-4e2c-b2d2-581876f56d77" # All India Pincode Directory along with Contact Details
    resource_id_2 = "7eca2fa3-d6f5-444e-b3d6-faa441e35294" # All Locality Search
    resource_id_3 = "6176ee09-3d56-4a3b-8115-21841576b2f6" # All India Pincode Directory no telegana details found
    resource_id_4 = "04cbe4b1-2f2b-4c39-a1d5-1c2e28bc0e32" # All India Pincode directory with contact details along with Latitude and longitude
    api_key = "642f4b9bfbc00aa76834551930785f93"
    
    records = 0
     
    india_pincode_lists = IndiaPincodeList.where('UPPER(statename) = ?', statename.upcase)
  
    india_pincode_lists.each do |indi|
      pincode =  indi.pincode
      filters = "filters[pincode]=#{indi.pincode}"
  
      api_url = "#{base_url}?resource_id=#{resource_id_1}&api-key=#{api_key}&#{filters}" 
  
      uri = URI(api_url)
      jsonArray = Net::HTTP.get(uri)
    
      json = JSON.parse(jsonArray)
        json["records"].each do |o|
          ### update local database with the state in the pincode
          indi.delay(:queue => 'update state for pincode', priority: 100).update(:statename => o["statename"])
          records += 1
        end
    end
    return records
  end
  
  
    # if params.has_key?(:pincode)
#       filters = "filters[pincode]=504273"
#     end
#    filters = "filters[pincode]=504273"
#https://data.gov.in/api/datastore/resource.json?resource_id=&api-key=642f4b9bfbc00aa76834551930785f93&filters[Localitydetail1]=All%20Localities&limit=1000
# {"id":"979","timestamp":"2016-03-18 15:56:22","StateName":"ANDHRA PRADESH","DistrictName":"ANANTHAPUR","Subdistname":"Chilamathur","Villagename":"Chilamathur","Localitydetail1":"All Localities","Localitydetail2":"NA","Localitydetail3":"NA","OfficeName":"Chilamathur S.O","Pincode":"515341"}
 
    # resource_id_1 = "0a076478-3fd3-4e2c-b2d2-581876f56d77" # All India Pincode Directory along with Contact Details
#     resource_id_2 = "7eca2fa3-d6f5-444e-b3d6-faa441e35294" # All Locality Search
#     api_key = "642f4b9bfbc00aa76834551930785f93"
#     limit=1000
#     # Localitydetail1
#     filters = "filters[statename]=TELANGANA"
#      # if params.has_key?(:pincode)
#  #       filters = "filters[pincode]=504273"
#  #     end
#  #    filters = "filters[pincode]=504273"
#  #https://data.gov.in/api/datastore/resource.json?resource_id=&api-key=642f4b9bfbc00aa76834551930785f93&filters[Localitydetail1]=All%20Localities&limit=1000
#  # {"id":"979","timestamp":"2016-03-18 15:56:22","StateName":"ANDHRA PRADESH","DistrictName":"ANANTHAPUR","Subdistname":"Chilamathur","Villagename":"Chilamathur","Localitydetail1":"All Localities","Localitydetail2":"NA","Localitydetail3":"NA","OfficeName":"Chilamathur S.O","Pincode":"515341"}
#
#     api_url = "https://data.gov.in/api/datastore/resource.json?resource_id=#{resource_id_1}&api-key=#{api_key}&#{filters}&limit=#{limit}"
#
#     uri = URI(api_url)
#     jsonArray = Net::HTTP.get(uri)
#     #JSON.parse(response)
#     @india_pincode_lists = JSON.parse(jsonArray)
    #render json: @india_pincode_lists
    # respond_to do |format|
#        # format.html { @india_pincode_lists, notice: 'India pincode list found.' }
#        format.html
#        format.json {render json: @india_pincode_lists}
#
#     end
   
    # url = URI.encode(api_url)
#
#     @response = url_response url
#     render json: @response
  # All India Pincode Directory along with Contact Details https://data.gov.in/api/datastore/resource.json?resource_id=0a076478-3fd3-4e2c-b2d2-581876f56d77&api-key=642f4b9bfbc00aa76834551930785f93&filters[statename]=TELANGANA

########################
  
  # All India Pincode Directory  no telegana details found
  # https://data.gov.in/api/datastore/resource.json?resource_id=6176ee09-3d56-4a3b-8115-21841576b2f6&api-key=642f4b9bfbc00aa76834551930785f93&filters[statename]=TELANGANA

  ###########################
  #All India Pincode directory with contact details along with Latitude and longitude
  #  https://data.gov.in/api/datastore/resource.json?resource_id=04cbe4b1-2f2b-4c39-a1d5-1c2e28bc0e32&api-key=642f4b9bfbc00aa76834551930785f93&filters[statename]=TELANGANA
 
  ###################### working this one 
 
  # https://data.gov.in/api/datastore/resource.json?resource_id=6176ee09-3d56-4a3b-8115-21841576b2f6&api-key=642f4b9bfbc00aa76834551930785f93&filters[statename]=TELANGANA&fields=officename,pincode,officeType,Deliverystatus,divisionname,regionname,circlename,Taluk,Districtname,statename,Telephone,Related Suboffice
  #https://data.gov.in/api/datastore/resource.json?resource_id=6176ee09-3d56-4a3b-8115-21841576b2f6&api-key=642f4b9bfbc00aa76834551930785f93&filters[statename]=ANDHRA%20PRADESH&fields=officename,pincode,officeType,Deliverystatus,divisionname,regionname,circlename,Taluk,Districtname,statename
  
 #Your API KEY for Open Government Data (OGD) Platform India is: 642f4b9bfbc00aa76834551930785f93  https://data.gov.in/api/datastore/resource.json?resource_id=6176ee09-3d56-4a3b-8115-21841576b2f6&api-key=YOURKEY&filters[field1]=field1_value&fields=field1,field2,field3&sort[field1]=asc 
 #officename,pincode,officeType,Deliverystatus,divisionname,regionname,circlename,Taluk,Districtname,statename,Telephone,Related Suboffice,Related Headoffice
 
end
