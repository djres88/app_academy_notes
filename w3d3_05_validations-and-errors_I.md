##Validations vs. Constraints
* *Constraints* are for the db. They're defined when you're doing migrations.
* *Validations* are defined at the model level

**Use both!** Validations are often the easier of the two, though. They give nicer errors, and they're easy to add for new data.

* When does *validation* happen? When you call `save/save!` on a model
  - ActiveRecord runs the validations to check whether the data can be persisted permanently to the DB
  - If validations fail, the object will be marked as invalid
    * `save` will return false instead of true
    * `save!` will instead raise an error

##`valid?``
* Before saving, ActiveRecord calls the `valid?` method on the object.
  - If it's false, ActiveRecord won't actually perform the SQL `INSERT/UPDATE`
* You can test `valid?` yourself
```ruby
class Person < ActiveRecord::Base
  validates :name, :presence => true
end

Person.create(:name => "John").valid? # => true
Person.create(:name => nil).valid? # => false
```

##`errors`
* `#errors` method returns an instance of `ActiveModel::errors`; can be used like a hash
  - keys are attribute names
  - values are arrays of all the errors for each attribute
```ruby
class Person < ActiveRecord::Base
  validates :name, :presence => true
end
p = Person.new
p.errors
#=> {}
p.valid?
#=> false
p.errors
# { name: ["can't be blank"] }
p.save!
#=> ActiveRecord::RecordInvalid: Validation failed: Name can't be blank
```
* If you want the above ActiveRecord error to fail with a readable message, call `[record].errors.full_messages`:
```ruby
p = Person.new
p.errors.full_messages
#=> ["Name can't be blank"]
```

##Validators
### `presence`
* Straightforward
```ruby
class Person < ActiveRecord::Base
  # must have name, login, and email
  validates :name, :login, :email, :presence => true
end
```
* Check whether an associated object exists
```ruby
class Team < ActiveRecord::Base
  belongs_to :league
  validates :league, presence: true
```
  - Note that we want to check for the presence of the associated object (`league`), NOT the foreign key (`league_id`)

### `uniqueness`
* Straightforward
```ruby
class Account < ActiveRecord::Base
  # no two Accounts with the same email
  validates :email, :uniqueness => true
end
```
* With `:scope` option:
```ruby
class Holiday < ActiveRecord::Base
  # no two Holidays with the same name for a single year
  validates :name, :uniqueness => {
    :scope => :year,
    :message => "should happen once per year"
  }
end
```

##Database vs Model Layer
Validation	   | Database Constraint                                  |	Model Validation
---------------|------------------------------------------------------|------------------
Present	       | null: false	                                        |  presence: true
All Unique   	 | add_index :tbl, :col, unique: true	                  |  uniqueness: true
Scoped Unique	 | add_index :tbl, [:scoped_to_col, :col], unique: true |
