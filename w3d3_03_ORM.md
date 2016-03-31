#Object Relational Mapping

An object relational mapping is the system that translates between SQL records and Ruby (or Java, or Lisp...) objects. The ActiveRecord ORM translates rows from your SQL tables into Ruby objects on fetch, and translates your Ruby objects back to rows on save.

The ORM also empowers your Ruby classes with convenient methods to perform common SQL operations: for instance, if the table physicians contains a foreign key referring to offices, ActiveRecord will be able to provide your Physician class a method, #office, which will fetch the associated record.

Using ORM, the properties and relationships of the objects in an application can be easily stored and retrieved from a database without writing SQL statements directly and with less overall database access code.

#Model classes and ActiveRecord::Base

For each table, we define a Ruby model class. An *instance of the model* will represent an individual *row in the table*.

For example, a physicians table in SQL will have a corresponding Physician model class in Ruby. When we fetch rows from the physicians table, we will get back Physician objects.

In Ruby, all model classes extend `ActiveRecord::Base`. `ActiveRecord::Base` contains built-in methods that will allow us to fetch and save Ruby objects from/to the SQL table.

Here are some of the more important methods that ActiveRecord provides (we wrote a few of these yesterday):
##1. `::find` & `::all`
```Ruby
Pokemon.all #returns all instances (rows) of Pokemon
Pokemon.find(92) #returns the Pokemon listed by primary key (id) 92
```

##2. `::where` Queries
You can't always look things up by primary key. Here's how you look them up by another column's value (here, `name`):
```Ruby
Pokemon.where("name = ?", "Pikachu")
#SAME AS:
  SELECT *
  FROM pokemon
  WHERE pokemon.name = 'Pikachu'
```
Note the use of the `?` interpolation character. This avoids SQL injection attacks.

ActiveRecord also lets you query without SQL fragments like so:
```Ruby
Pokemon.where(:name => ["Pikachu", "Charzard", "Nothingman"])
Pokemon.where(:exp_pts => (50..100))
```

##3. Update/Insert Rows
`ActiveRecord::Base` lets you create (or update) objects pretty easily. Here's how we might create a pokemon:

```Ruby
p = Pokemon.new

p.name = 'Pikachu'
p.size_in_inches = 5
p.exp_pts = 0
```
This DOES NOT save p to the database, though. For that we need `#save!`:
```Ruby
p.save!
```

We can also do all this in one step with `#create!`:
```Ruby
Pokemon.create!(
  :name => "Pikachu",
  :size_in_inches => 5,
  :exp_pts => 0
)
```

You can destroy that same record with `#destroy`:
```Ruby
p.destroy #destroys this instance of Pikachu
```

#Rails Consoles
* You can play with your Rails app: `rails c` is rails version of pry.
  - `reload!` (instead of load) will load all the model classes
