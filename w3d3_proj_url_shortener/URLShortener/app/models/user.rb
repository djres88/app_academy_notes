class User < ActiveRecord::Base

  validates :email, uniqueness: true, presence: true

  has_many :shortened_urls,
    class_name: :ShortenedUrl,
    foreign_key: :submitter_id,
    primary_key: :id

end
