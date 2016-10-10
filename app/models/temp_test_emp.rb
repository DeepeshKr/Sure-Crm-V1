class TempTestEmp < ActiveRecord::Base
  self.table_name = 'temp_test_emp' 
  
  # if Rails.env == "development"
 #     ActiveRecord::Base.establish_connection :development_cccrm
 #  elsif Rails.env == "production"
 #     ActiveRecord::Base.establish_connection :production_cccrm
 #  end

 #ActiveRecord::Base.establish_connection("#{Rails.env}_cccrm")
 #hash =  ActiveRecord::Base.connection.exec_query("select temp_test_emp_sequence.nextval from dual")[0]
 
  #Xscrpt.connection.select_value("select nextval('#{Xscrpt.sequence_name}')").to_i
 before_create :set_account_number
 def set_account_number
   self.temp_test_emp_id = "SELECT nextval('temp_test_emp_sequence') AS my_next_id"
 end
end


#
# create table temp_test_emp ( id number(10),
# data_text varchar2(50),
# date_more varchar2(50),
# constraint pk_emp_id PRIMARY KEY(id)
# );
#
# Create sequence temp_test_emp_sequence start with 1
# increment by 1
# minvalue 1
# maxvalue 10000;


# create trigger trg_temp_test_emp_id
#       before insert on temp_test_emp
#       for each row
#     begin
#       select id_seq.nextval
#         into :new.id
#         from dual;
#     end;
  
#insert into temp_test_emp (emp_id,fname,lname) 