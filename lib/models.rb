require_relative 'db_connection'
require_relative 'sql_object'
require_relative 'associatable'

class Car < SQLObject
  belongs_to :human, :foreign_key => :owner_id

  finalize!
end

class Human < SQLObject
  self.table_name = "humans"
  has_many :cars, :foreign_key => :owner_id

  finalize!
end
