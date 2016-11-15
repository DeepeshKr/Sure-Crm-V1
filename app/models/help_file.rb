class HelpFile < ActiveRecord::Base
  mount_uploader :screen_shot, HelpFileUploader
  require 'csv'
  belongs_to :employee, foreign_key: "employee_id"
  validates :link,  uniqueness: { message: "The link is required and has to be unique, check if it has been used earlier" }
  
  def clickable_url host    
    
    return nil  if self.link.include? "Method"
    return nil  if self.link.include? "new"
    return nil  if self.link.include? "edit"
    return nil  if self.link.include? ":id"
    
    if host == "192.168.1.10"
      return "http://192.168.1.10:89/#{self.link}" 
    elsif host == "3.0.3.57"
      return "http://3.0.3.57/#{self.link}" 
    elsif host == "3.0.3.26"
      return "http://3.0.3.26:120/#{self.link}" 
    end
    
  end
  
  def self.import(file)
      
    # delete_help_files  = HelpFile.where("id > 10149")
#
#     delete_help_files.each do |dele_old|
#       dele_old.destroy
#     end
    
      CSV.foreach(file.path, headers: true) do |row|
    
        help_file_hash = row.to_hash # exclude the price field
        help_file_lists = HelpFile.where(link: help_file_hash["link"])
        
        name_l = help_file_hash["name"].strip if help_file_hash["name"]
        link_l = help_file_hash["link"].strip if help_file_hash["link"]
        tags_l = help_file_hash["tags"].strip if help_file_hash["tags"]
        description_l = help_file_hash["description"].strip if help_file_hash["description"]
        employee_id_l = help_file_hash["employee_id"]
        domain_l = help_file_hash["domain"].strip if help_file_hash["domain"]
        controller_l = help_file_hash["controller"].strip if help_file_hash["controller"]
        action_l = help_file_hash["action"].strip if help_file_hash["action"]
        
        parameters_l = nil
        if link_l.present?
          parameters_l = help_file_hash["parameters"].strip if help_file_hash["parameters"]
          parameters_l = nil  if link_l.include? "Method"
          parameters_l = nil  if link_l.include? "new"
          parameters_l = nil  if link_l.include? "edit"
          parameters_l = nil  if link_l.include? ":id"
        end
        
        if help_file_lists.present?
        	#add execption
          help_file_list = help_file_lists.first
 
        	help_file_list.update(name: name_l,
          	link:  link_l,
          	tags:  tags_l,
          	description:  description_l,
          	employee_id:  employee_id_l,
          	domain:  domain_l,
          	controller:  controller_l,
          	action:  action_l,
          	parameters:  parameters_l)

        else

         HelpFile.create(name: name_l,
          	link:  link_l,
          	tags:  tags_l,
          	description:  description_l,
          	employee_id:  employee_id_l,
          	domain:  domain_l,
          	controller:  controller_l,
          	action:  action_l,
          	parameters:  parameters_l)

        end # end if !pincode_list.nil?
      end # end CSV.foreach
  end # end self.import(file)
  
end
