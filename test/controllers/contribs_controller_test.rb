require 'test_helper'

class ContribsControllerTest < ActionController::TestCase
  setup do
    @contrib = contribs(:one)
    User.first.confirm
    sign_in User.first
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:contribs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get new based on intrerest" do
    @interest = interests(:one)
    get :new, in_reply_to: @interest.id
    assert_response :success
  end


  test "should create contrib" do
    assert_difference('Contrib.count') do
      post :create, contrib: { description: @contrib.description, title: @contrib.title }
    end

    assert_redirected_to contrib_path(assigns(:contrib))
  end

  test "should show contrib" do
    get :show, id: @contrib
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contrib
    assert_response :success
  end

  test "should update contrib" do
    patch :update, id: @contrib, contrib: { description: @contrib.description, title: @contrib.title }
    assert_redirected_to contrib_path(assigns(:contrib))
  end

  test "should destroy contrib" do
    assert_difference('Contrib.count', -1) do
      delete :destroy, id: @contrib
    end

    assert_redirected_to contribs_path
  end

  test "should update all event data" do
    assert_difference('Event.count', +1) do
      post :bulk_update, contrib: [{:id=>@contrib.id, :event=>{:start=>"2016-04-08T11:00:00", :end=>"2016-04-08T13:00:00"}}]
    end
    assert_response :success
  end

  test "should reject updates of event data if contrib does not exist" do
    assert_raises(ActiveRecord::RecordNotFound) do
      post :bulk_update, contrib: [{:id=>"42", :event=>{:start=>"2016-04-08T11:00:00", :end=>"2016-04-08T13:00:00"}}]
    end
  end

end
