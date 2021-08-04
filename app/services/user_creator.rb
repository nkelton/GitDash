class UserCreator < BaseService

  attr_reader :user_attrs

  def initialize(user_attrs)
    super()
    @user_attrs = user_attrs
  end

  def call
    ActiveRecord::Base.transaction do
      user = User.create!(user_attrs)
      Profile.create!(
        user_id: user.id
      )
      return success(user)
    end
  end

end