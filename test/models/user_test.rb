require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "create user" do
  	user = User.new( email: "this@that.com", username: "this")
    assert user.valid?
  end
  test "created user is not admin" do
  	user = User.create( email: "this@that.com", username: "this")
    assert not(user.is_admin)
  end  
end
