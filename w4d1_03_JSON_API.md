#Building a JSON API
* For *non-browser* clients, it's usually better to reply w/ JSON
  - Browser clients are people; they want HTML rendered
  - Non-browser clients are machines (usually); they just want data
* You'll want to know how to return JSON for a number of reasons
  - 3rd party developers
  - Retrieve your own data from *within* the app

#JSON & Rails
* Key: get your controllers to convert model objects into JSON, and then return the JSON
  1. Controllers --> Model Objects --> JSON
  2. JSON --> Controllers --> User (gets JSON)

* Models: `to_json`
 - Can turn model objects into JSON w/ `to_json` method:
 ```bash
  $ rails c
  > HogwartsStudent.first.to_json
  => "{\"created_at\":\"2013-06-04T00:31:04Z\",\"fname\":\"Harry\",
\"house_id\":1,\"id\":1,\"lname\":\"Potter\",
\"school_id\":1,\"updated_at\":\"2013-06-04T00:31:04Z\"}"
 ```

* Controllers: `render json:`
  - Usually, we respond by rendering HTML. But it's easy to render JSON:
  ```ruby
  def index
    users = User.all
    render json: users
  end
  ```
