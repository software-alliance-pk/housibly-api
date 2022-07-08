require "test_helper"

class UserPreferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_preferences_create_url
    assert_response :success
  end
end
