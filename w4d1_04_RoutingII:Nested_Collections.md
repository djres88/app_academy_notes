#Routing II: Nested Collections
Common for resources to have "children". Suppose your API includes these models:
```ruby
#app/models/league.rb
class League < ActiveRecord::Base
  has_many :teams
end
#app/models/team.rb
class Team < ActiveRecord::Base
  belongs_to :league
end
```

Nested routes allow you to capture this relationship:
```ruby
#routes.rb
MLBApp::Application.routes.draw do
  resources :leagues do
    #Provide a route to get to all the teams for a given league:
    resources :teams, only: :index
  end

  #provides the seven typical routes:
  resources :teams
end
```
Now we get a `/leagues/:league_id/teams` route. Requests will be sent to the `TeamsController#index` action -- but note that we have *two* routes for this action. We can only make one response, however. How do we handle that? In the `TeamsController`:
```ruby
class TeamsController
  def index
    #If this url request is the nested one...
    if params.has_key?(:league_id)
      @teams = Team.where(league_id: params[:league_id])
    else
      @teams = Team.all
    end

    render json: @teams
  end
end
```

* Note that we use `only:` to tell Rails the routes we want to create. If we don't specify, Rails will create all 7 routes
* As a general rule, never generate any of the *member* routes when nesting.
  - Member routes (NO NEST): `show`, `edit`, `update`, `destroy`
  - Collection routes (NESTING OK): `index`, `new`, `create`
  - Usually you're only nesting index
* However, be sure that exactly one URL maps to the representation of a resource
