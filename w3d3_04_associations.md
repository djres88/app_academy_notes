#Associations I: `belongs_to` and `has_many`

Associations tell AR that there is a connection between the two models. Here we modify the associated model classes:
```Ruby
class Pokemon < ActiveRecord::Base
  belongs_to(
    :player, #Calling player on a particular pokemon will return that pokemon's owner.
    :class_name => "Player",
    :foreign_key => :player_id,
    :primary_key => :id
  )
end

class Player < ActiveRecord::Base
  has_many(
    :pokemons, #Calling pokemons on a particular player will return an array of that player's pokemon.
    :class_name => "Pokemon",
    :foreign_key => :player_id,
    :primary_key => :id
  )
end
```

The belongs_to and has_many methods exist in a module named `ActiveRecord::Associations::ClassMethods`. ActiveRecord::Base extends this module, so the association methods are available as class methods. These class methods define instance methods: in this case, Course#professor and Professor#courses. Class methods like this are called macros. These let us write more simply:
