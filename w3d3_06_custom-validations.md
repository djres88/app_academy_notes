##Custom methods
1. To a specific errors hash:
```ruby
class User < ActiveRecord::Base
  #Note: validate not validates
  validate :bad_response

  private
  def is_GOT_great?
    unless user_response == "Yes"
      errors[:user] << "is incorrect. GOT is great."
      #How do you know errors[:user] exists? Do you have to check? You could do a before_action thing, per what Jon talked about today.
    end
  end
end
```
* We add a message to the `errors` hash
* Note: message doesn't need to mention variable name; when you call `full_messages`, rails will prefix the msg for you ("User is wrong")
```ruby
u = User.new
u.errors.full_messages
#=> ["User is incorrect. GOT is great."]
```

2. To a general error (`errors[:base]`)
```ruby
class Mess < ActiveRecord::Base
  validate :fix_my_mess

  def fix_my_mess
    if @user.user_answer == "no"
      errors[:base] << "The user has refused to fix my mess."
    end
  end
end
```

Need to know?
<!-- ##Custom Validators
* Custom validators are *classes* that extend `ActiveModel::EachValidator`.
  - Do this when only you want to reuse validation logic for multiple models or multiple columns
  - Otherwise it's just overly complicated
* Use `validate_each` for the method:
```ruby
class EmailValidator < ActiveModel::EachValidator
  CHECK = ["Bad", "Worse", "Worstest"]
  def validate_each(record, value)
    unless value =~ CHECK
      message = options[:message] || "is not an email"
      ...
```
