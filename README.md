RubyData
=====

RubyData is a helpful library that implements ORM that allows you to make
updates to a SQLite3 database without writing one line of SQL code. Inspired by Rails ActiveRecord.

Demo
--------

As you explore this document, you may find it helpful to reference the sample objects file `lib/models.rb` which is connected to a complementary database.

To load:
  * Navigate to the `lib` directory
  * Using `irb` or `pry`, type `load 'models.rb'`
  * Query the database through commands such as `Car.all` `Human.all` `Car.find(1)` etc.

How To Use
---------------

Things you need:
  * Ruby
  * SQLite3

Similar to Rails ActiveRecord,
RubyData converts tables in a SQLite3 database into instances of the
`SQLObject` class.

`SQLObject` is a very lightweight version of `ActiveRecord::Base`.

Available methods
---------------------
* `#all`
* `#first`
* `#last`
* `#update(params)`
* `#create(params)`
* `#delete`
* `#save`
* `#find(id)`
* `#where(params)`

Available associations:
----------------------------------------
* `::belongs_to`
* `::has_many`
