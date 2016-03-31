class ShortenedUrl < ActiveRecord::Base
  include SecureRandom
  validates :short_url, :long_url, :submitter_id, presence: true

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while self.exists?(code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!({short_url: self.random_code, long_url: long_url, submitter_id: user.id})
  end

  belongs_to :users,
    class_name: :User,
    foreign_key: :submitter_id,
    primary_key: :id


end
