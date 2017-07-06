require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)

    vals = params.values
    where_line = params.map do | param |
      k, v = param
      "#{k} = ?"
    end

    where_line = where_line.join("AND ")

    result = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
      SQL
      parse_all(result)
  end
end

class SQLObject
  extend Searchable
end
