#Scopes
* When queries are re-used, write them as a **scopes**
  - scope: fancy name for a class method that holds all/part of a query
```ruby
class Team < ActiveRecord::Base
  def self.by_wins
    self
      .select("teams.*, COUNT(record.wins) AS win_count")
      .joins(:record)
      .group("teams.id")
      .order("win_count DESC")
  end
end
```
* We can now use `Team.by_wins`
* Note that this returns a `Relation` object, which means we can tack query methods onto it
`Team.by_wins.limit(5)` would get the top 5 teams (by wins)
