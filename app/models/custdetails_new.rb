class  CUSTDETAILS_NEW < ActiveRecord::Base
    if Rails.env == "development"
          establish_connection :development_cccrm
        elsif Rails.env == "production"
          establish_connection :production_cccrm
        end
        
      self.sequence_name = 'CUSTDETAILS_NEW_SEQ'
      #establish_connection "#{Rails.env}_cccrm"
      self.table_name = 'CUSTDETAILS_NEW'
      self.primary_key = 'RowID'
      alias_attribute :row_id, :RowID
      #CUSTDETAILS_NEW_SEQ
    before_create :set_account_number
    def set_account_number

      # if Rails.env == "development"
#          ActiveRecord::Base.establish_connection :development_cccrm
#       elsif Rails.env == "production"
#          ActiveRecord::Base.establish_connection :production_cccrm
#       end
#
#       hash =  ActiveRecord::Base.connection.exec_query("select CUSTDETAILS_NEW_SEQ.nextval from dual")[0]
#       self.row_id = hash
#       # establish_connection.connection.select_value("SELECT nextval('CUSTDETAILS_NEW_SEQ') AS my_next_id").to_i
#       # row_id = ActiveRecord::Base.connection.exec_query("select ordernumc.nextval from dual")[0]
# #       self.row_id = row_id
        self.row_id = "SELECT nextval('CUSTDETAILS_NEW_SEQ') AS my_next_id"
#        # self.row_id = ActiveRecord::Base.connection.exec_query("SELECT nextval('CUSTDETAILS_NEW_SEQ') AS my_next_id")
#
#        if Rails.env == "development"
#          ActiveRecord::Base.establish_connection :development_testora
#        elsif Rails.env == "production"
#          ActiveRecord::Base.establish_connection :production_testora
#        end
      # self.row_id = my_next_id_sequence
    end
    def my_next_id_sequence
      get_data = self.find_by_SQL "SELECT last_number FROM user_sequences where sequence_name='CUSTDETAILS_NEW_SEQ'"
      get_data[0].last_number
    end
end
#  test = CUSTDETAILS_NEW.new(ordernum: 1234)
#test.save