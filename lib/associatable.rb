require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.chars.map { |e| e.downcase  }.join + 's'
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
      @class_name = options[:class_name] || "#{name.capitalize}"
      @primary_key = options[:primary_key] || :id
      @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
      @class_name = options[:class_name] || "#{name.to_s.capitalize.singularize}"
      @primary_key = options[:primary_key] || :id
      if options[:foreign_key].nil?
        fix_string = []
        self_class_name.chars.each.with_index do | ch,i |
          if ch == ch.upcase && i == 0
            fix_string << ch.downcase
          elsif ch == ch.upcase
            fix_string << "_" + ch.downcase
          elsif i == self_class_name.length - 1 && ch == "s"
            ch
          else
            fix_string << ch
          end
        end
        fix_string = fix_string.join
        @foreign_key = "#{fix_string}_id".to_sym
      else
        @foreign_key = options[:foreign_key]
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method("#{name}") do
      foreign_key = self.send("#{options.foreign_key}")
      foreign = options.model_class.find(foreign_key)
    end
  end

  def has_many(name, options = {})
    arg_options = options
    options = HasManyOptions.new(name, "#{self}", options)
    define_method("#{name}") do
      primary_key = self.send("#{options.primary_key}")
      my_objects = options.model_class.where(options.foreign_key => primary_key)
    end
  end
end
