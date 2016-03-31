##Joins
* Refer to the joins demo: https://github.com/appacademy/JoinsDemo
* We can create joins tables for the purpose of storing keys from two other tables, creating many-to-many relationships
  - `casting` was an example of this (joins actors to movies)
  - yes?

##N+1 Problem
* Be aware of how many queries you're running in your code
* the following code runs one query for *every iteration*:
```ruby
class User
  def n_plus_one_post_comment_counts
    posts = self.posts
    # Query #1: ActiveRecord runs SELECT * FROM posts WHERE posts.author_id = ?
    # (`?` gets replaced with `user.id`)

    post_comment_counts = {}
    posts.each do |post|
      # This query gets performed once FOR EACH POST.
      post_comment_counts[post] = post.comments.length
      # QUERY N: SELECT * FROM comments WHERE comments.post_id = ?
      # (`?` gets replaced with `post.id`)
    end

    post_comment_counts
  end
end
```

###Solution: Fetch All Comments with `.includes`
```ruby
class User
  def better_query
    posts = self.posts.includes(:comments)
    #Makes two queries...
    #1: SELECT * FROM posts WHERE post.author_id = ?
      # ? => user.id
    #2: SELECT * FROM comments WHERE comments.post_id IN ?
      # ? => self.posts.map(&:id)
    post_comment_counts = {}
    posts.each do |post|
      # Don't need to fire query; we've already prefetched the association:
      post_comment_counts[post] = post.comments.length
    end

    post_comment_counts
  end
end
```

###`.includes` +
* You can "eagerly load" as many associations as you want:
```ruby
comments = user.comments.includes(:post, :parent_comment)
```
* You can also do nested prefetches
```ruby
posts = user.posts.includes(:comments => [:author, :parent_comment])
first_post = posts[0]
```
  - Not only prefetches `first_post.comments`, but also prefetches `first_post.comments[0]` and even `first_post.comments[0].author` and `first_post.comments[0].parent_comment.`

##`joins`
* To perform a SQL `JOIN`, use `joins`
* Like `includes`, it takes the name of an association
```ruby
class Student
  def self.student_enrollments
    Student.joins(:enrollments)
      #SELECT users.* FROM users JOIN enrollments ON enrollments.student_id = student.id
    end
  end
```
* Default `joins` is to perform inner join. If we wanted to return null values -- forex, if we wanted to return a user's posts with 0 comments -- we'd need an outer join:
```ruby
posts_with_counts = self
  .posts
  .select("posts.*, COUNT(comments.id) AS comments_count") # more in a sec
  .joins("LEFT OUTER JOIN comments ON posts.id = comments.post_id")
  .group("posts.id") # "comments.post_id" would be equivalent
```
  - Note that because you're not using an existing association, you need to specify the primary and foreign key columns for the join
