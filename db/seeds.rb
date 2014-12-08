# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
states = ["Andhra Pradesh",  "Arunachal Pradesh", "Assam",  "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana",
"Himachal Pradesh", "Jammu & Kashmir", "Jharkhand",  "Karnataka", "Kerala", "Madhya Pradesh",  
"Maharashtra", "Manipur",  "Meghalaya", "Mizoram", "Nagaland", "Odisha (Orissa)", "Punjab", 
"Rajasthan", "Sikkim", "Tamil Nadu",  "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", 
"West Bengal", "Andaman and Nicobar Island",  "Chandigarh", "Dadra and Nagar Haveli",
 "Daman and Diu", "Lakshadweep", "Delhi – National Capital Territory", "Puducherry (Pondicherry)"]
states.each{|d| State.where(:name => d).first_or_create}

salutes = ["Mr", "Mrs", "Dr", "Prof", "Ms"]
salutes.each{|d| Salute.where(:name => d).first_or_create}

 employeetypes = [
  [ "Temporary", 1 ],
  [ "Probation", 2 ],
  [ "Trainee", 3 ],
  [ "Permanent", 4 ],
  [ "Resigned", 5 ],
  [ "Dismissed", 6 ],
]

employeetypes.each do |name, sortorder|
#  EmploymentType.first_or_create( name: name, sortorder: sortorder )
end

employeerole = [
  [ "Management", 1 ],
  [ "Manager", 2 ],
  [ "Employee", 3 ]
]
employeerole.each do |name, sortorder|
 #EmployeeRole.create( name: name, sortorder: sortorder )
end

# these are new creations

intusers = ["Customer", "Employee", "Expert"]
#intusers.each{|d| InteractionUser.where(:name => d).first_or_create}

interactionstatuses = [
  [ "New Interaction", "New Interaction", 1 ],
  [ "Under process", "Assigned and allocated", 2 ],
  [ "Under process", "Working on solving", 3 ],
  [ "Closed", "Resolution Provided", 4 ]
]
# done

interactionstatuses.each do |cust, internal, sort|
 #InteractionStatus.create(customer_description:cust,  internal_description:internal,  sortorder:sort)
end

interactionpriorities = [
  [ "Low",  1 ],
  [ "Normal", 2 ],
  [ "High",  3 ],
  [ "Critical", 4 ]
]
#done checked
interactionpriorities.each do |name, sort|
  #InteractionPriority.create(  name: name,   sortorder: sort)
end

producttypes = ["Standard", "Mixed", "Not to sold loose"]
#producttypes.each{|d| ProductType.where(:name => d).first_or_create}

campignstages = [
  [ "New",  1 ],
  [ "Active", 2 ],
  [ "Paused",  3 ],
  [ "Retired", 4 ]
]

campignstages.each do |name, sort|
 #CampaignStage.create(  name:name, sortorder:sort)
end

interactioncategoris = [
  [ "Not shipped",  1 , 24],
  [ "Damaged",  1 , 24]
]

interactioncategoris.each do |name, sort, hours|
 #InteractionCategory.create(  name:name,   sortorder: sort, resolutionhours:hours)
end


#not done only the below one

productcategories = [
  [ "Home",  0.125, "Home products" ],
  [ "Health and Slimming",  0.125, "Health and slimming products" ]
]

productcategories.each do |name, vat, desc|
# ProductCategory.create( name:name, vatpercent:vat, description:desc)
end

addresstypes = ["Primary", "Alternative", "Mailing", "Billing", "Home", "Office", "Temporary", "Communication" ]
#addresstypes.each{|d| AddressType.where(:name => d).first_or_create}

addressvalids = ["New", "Valid", "In-Valid", "Non-Delivery", "Other" ]
#addressvalids.each{|d| AddressValid.where(:name => d).first_or_create}

ordersources = ["Telebrands Call Centre", "Internet" ]
#ordersources.each{|d| OrderSource.where(:name => d).first_or_create}


