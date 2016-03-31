Your best resource is http://guides.rubyonrails.org/active_record_validations.html

##Validations for `length` and `VARCHAR`
Gotta test this, but...
```ruby
validates :username, length: { minimum: 6, maximum: 20 }
```

##`:allow_nil`
* Saw this with passwords
```ruby
validates :password, length: {
  minimum: 6 }, allow_nil: true
```
 - So we don't raise an error when we retrieve password from the db, bc in fact there's not a password column in the db; it's called password_digest instead (and stored as a hash)

##`:allow_blank`
```ruby
validates :suffix, inclusion: { in: %w(Jr. Sr. II III IV V VI) }, allow_blank: true
```

##`:message`
If you don't want to get a nasty error, you could add a custom error message:
```ruby
class Coffee < ActiveRecord::Base
  validates :hot_or_cold, inclusion: { is: "hot" }, message: "#{value} is not hot coffee. You're a quitter."
end
```

##`if` and `unless`
Sometimes the presence validation is conditional. We can handle that with `if` and `unless`:
```ruby
class Order < ActiveRecord::Base
  validates :card_number, presence: true, if: :paid_with_card?

  def paid_with_card?
    payment_type == "card"
  end
end
```
