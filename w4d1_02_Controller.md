#About
* ActionController is "C" in MVC
  - After routing has determined which controller to use for a request, the *controller itself* must (a) process request and (b) produce appropriate output
* They're the "doers":
  - ask model layer to fetch data (MODEL/DB interaction)
  - process user input to save/update new data (MODEL/DB interaction)
  - build/send a response OR redirect user to a new path (VIEWS interaction)

#Methods/Actions
* Run `rails g controller PluralNounsController`.
* See controller inherits from ApplicationController, which gives it methods like `render` and `redirect_to`
* When app receives request, router determines which controller/action (method) to run.
  - e.g. if user goes to `vids/7`, router sees that it should call `VideosController#show`
  - If your controller doesn't have that method, ActiveRecord freaks out
* The typical methods you'll need correspond to routes:
```ruby
def index
end

def show
end

def new
end

def create
end

def update
end

def edit
end

def destroy
end
```

#Strong Params
* Several types of params come through with request
1. Query String (URL)
  - Available in hash-like object returned by `params`
  ```ruby
  #GET /video/7?status=current
  params[:id] == 7
  params[:status] == "current"
  ```
2. Request Body
  - Comes through with `POST`/`PATCH` (and `PUT`)
  - Usually comes from an HTML form which has been filled by the user
  - Rails combines the request body params with the query string params.
  **You can get both using `#params`**.
  ```ruby
  #POST {user: {name: "David"}}
  params[:name] == "David"
  ```
NOTE: You can't mass-assign without explicitly white-listing the attributes that the user can control:
```ruby
  def create
    @video = Video.new(params[:video]) #won't work!
    @video.save!
  end
  #Instead, want to user params built-in methods to whitelist which attributes user can edit/update:
  def create
    @video = Video.new(params[:video].permit(:title, :description))
    @video.save!
  end
```
Even better, DRY this out:
```ruby
  def create
    Video.create!(video_params)
  end

  def update
    @video = Video.find(params[:id]) #NB: The router sets params[:id] to the matched id from the requested path. That's because the controller needs to know which specific object to show, delete or (in this case) update.
    @video.updated!(video_params)
  end

  private
  def video_params
    params.require(:video).permit(:title, :description)
  end
```
