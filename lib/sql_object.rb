require_relative 'db_connection'
require 'active_support/inflector'
require_relative 'associatable'
require_relative 'searchable'

class SQLObject
  extend Associatable
  extend Searchable
  def self.columns
    if @columns.nil?
      columns = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          "#{table_name}"
        SQL
        @columns = columns[0].map(&:to_sym)
    else
      @columns
    end
  end

  def self.finalize!
    self.columns.each do | col |
      define_method("#{col}=") do | arg |
        attributes[col] = arg
      end
      define_method(col) do
        attributes[col]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    name = "#{self}"
    fix_string = []
    name.chars.each.with_index do | ch,i |
      if ch == ch.upcase && i == 0
        fix_string << ch.downcase
      elsif ch == ch.upcase
        fix_string << "_" + ch.downcase
      else
        fix_string << ch
      end
    end

    (fix_string << "s").join
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{table_name}"
      SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    objs = []
    (0...results.length).each do | i |
      objs << self.new(results[i])
    end
    objs
  end

  def self.first
    self.all[0]
  end

  def self.last
    self.all[-1]
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        "#{table_name}"
      WHERE
        id = ?
      SQL
    results.nil? ? nil : parsed_results = parse_all(results)
    parsed_results.first
  end

  def initialize(params = {})
    params.each do |k,v|
      key_sym = k.to_sym
        unless self.class.columns.include?(key_sym)
          raise Exception.new("unknown attribute '#{k}'")
        end
      self.send("#{key_sym}=", v)
    end
  end

  def attributes
    if @attributes.nil?
      @attributes = {}
    else
      @attributes
    end
  end

  def attribute_values
    cols = self.class.columns
    cols.map do | col |
      self.send(col)
    end

  end

  def insert
    cols = self.class.columns
    col_names = cols.join(",")
    vals = attribute_values
    question_marks = (["?"] * cols.length).join(",")
    DBConnection.execute(<<-SQL, *vals)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update(params = {})
    if params.empty?
      cols = self.class.columns
      vals = attribute_values
    else
      cols = params.keys
      vals = params.values
    end
    col_names = cols.map {|col| "#{col} = ?"}.join(",")
    id = self.id
    DBConnection.execute(<<-SQL,*vals, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names}
      WHERE
        id = ?
    SQL
  end

  def create

  end

  def save
    if self.class.find(self.id).nil?
      self.insert
    else
      self.update
    end
  end
end
