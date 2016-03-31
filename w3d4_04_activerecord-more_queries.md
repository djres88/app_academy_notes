#Dynamic Finders
* **For any column `x`, and AR model will respond to a message `find_by_X`**
```ruby
User.find_by_email_address("david@me.com")
```
  - Because AR overrides `method_missing?` to do this, you can get crazy and chain stuff
  ```ruby
  User.find_by_first_name_and_last_name("david", "resnick")
  ```

#Find by SQL
If an ActiveRecord query takes too long or gets too complicated, you can just do `find_by_sql`:
```ruby
User.find_by_sql(<<-SQL)
SELECT
  games.*
FROM
  games
JOIN (
  SELECT
    players.*
  FROM
    players
  LEFT OUTER JOIN
    scores ON players.score_id = scores.id
  GROUP BY
    players.id
  ORDER BY
    COUNT(scores.*)
  LIMIT 10
) ON ((games.home_team_id = players.id) OR (games.away_team_id = players.id))
```
