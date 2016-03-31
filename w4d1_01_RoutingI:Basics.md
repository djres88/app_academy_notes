#Purpose of Rails Router
* (1) Recognizes URLs, then (2) chooses a controller *method* to process the request
* ex: receives a `GET` request for `patients/17` and realizes that `PatientsController#show` must be called
  - Note: router matches on both HTTP method (GET/POST) *and* path (patients/17)

#Rails Default: Resource Routing
* In `config/routes.rb`:
```ruby
VideoDemo::Application.routes.draw do
  resources :videos
end
```
That one line generates 7 routes (one for each of 7 request/path combinations). Each route maps to a set of controller actions in VideosController.
HTTP Verb | Path            | Action |
----------|-----------------|--------|
GET       |/photos/         | index  |
GET       |/photos/new      | new    |
POST      |/photos/         | create |
GET       |/photos/:id      | show   |
GET       |/photos/:id/edit | edit   |
PATCH     |/photos/:id      | update |
DELETE    |/photos/:id      | destroy|
* paths with `:` (e.g. `:id`) are *dynamic*
  - can match any string
  - So `GET /videos/2` and `GET /videos/78` map to the same controller action (`show`)

#Controller Conventions
* Controllers named in plural (`VideosController`)
* For resources, also use plural (`resources: :videos`)

#RESTful
* In short, means that *all* actions should be thought of in terms of CRUD
  1. create
  2. read
  3. update
  4. destroy
* e.g. for a video like, we might create a `Like` object, instances of which would be created/seen/updated/destroyed based on user actions

#Route Helpers
* Methods to return a URL. Always prefer doing this to building own routes to string interpolation.
* Method names correspond to left column in rake routes (with `_url` tacked on). For `resources :videos`, the routes are:
  - `photos_url` : http://www.okay.com/videos
  - `new_photo_url` : ... /videos/new
  - `photo_url(@photo)` : ... /videos/#{@photo.id}
  - `edit_photo_url(@photo)` : ... /videos/#{@photo.id}/edit

* Many ERB methods that take a URL also take a `:method` option:
  ```ruby
  button_to(video_url(@video), method: :delete)
  link_to(video_url, method: :get)
  ```
* You can also embed query_string options into URL helpers:
  ```ruby
  video_url(recent: true) == http://www.okay.com/videos?recent=true
  ```

#Inspecting/Testing Routes
* `rake routes` in terminal
* Route name (in left column): add `_url` to get the route helper
