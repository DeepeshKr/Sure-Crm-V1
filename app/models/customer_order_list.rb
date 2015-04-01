class CustomerOrderList < ActiveRecord::Base
#  self.sequence_name = 'order_seq'

# before_create do
#     #since we can't use the normal set sequence name we have to set the primary key manually
#     #so the execute command return an array of hashes,
#     #so we grab the first one and get the nextval column from it and set it on id
#    self.ordernum = ActiveRecord::Base.connection.exec_query("select order_seq.nextval from dual")[0]
# end

# def get_sequence_id
#        # self.find_by_sql "select order_seq.nextval as order_num from dual"
#       return  ActiveRecord::Base.connection.exec_query("select order_seq.nextval as order_num from dual").fetch
#     end

#  def next
#  	return ActiveRecord::Base.connection.exec_query("select order_seq.nextval from dual")[0] 
#  	#CUSTOMER_ORDER_LISTS_SEQ
#  end
end
