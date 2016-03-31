##ActiveRecord's Querying Methods
* Very similar to SQL:
  - `group`,
  - `having`,
  - `includes`,
  - `joins`,
  - `select`,
  - `where`
  - And more
    * **Review Solutions to W3D2, W3D5 for Syntax!**
    * Also see http://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-select
* These queries return an object of type `ActiveRecord::Relation`
* `Relation` object is a lot like an `Array`; you can iterate thru (`.each`, `.map`), index into it (`Relation[5]`)
  - You can also string relation methods together:
  `Person.where("likes_dogs = ?", true).group("age").having("age > ?", 20)`
  - One big diff from array though: contents of `Relation` are not fetched until needed. This is why we say **queries are lazy**

###Query Laziness & Caching
```ruby
user = User.where("likes_dogs = ?", true) #No fetch yet

user.each { |user| puts user.name } #Performs fetch here
user.each { |user| puts user.name } #No second fetch; result is "cached"
```
* Takeaway: `Relation` is not evaluated (i.e. a db query is not fired) until the results are needed.
  - And it's not fired again if it's the same query; results are cached.
  - This saves us unnecessary db queries, but it can cause strangeness if you update the db between queries
    * In that case you'd need to reload the object you're querying (e.g. `dog5.reload`), but in practice that's not often necessary

##Laziness and Stacking Queries
Laziness is good bc we can stack queries w/o firing multiple times:
```ruby
georges = User.where("first_name = ?", "George")
georges.where_values
# => ["first_name = 'George'"]

george_harrisons = georges.where("last_name = ?", "Harrison")
george_harrisons.where_values
# => ["first_name = 'George'", "last_name = 'Harrison'"]
```
