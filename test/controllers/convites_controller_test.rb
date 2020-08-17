require 'test_helper'

class ConvitesControllerTest < ActionController::TestCase
  test "should get confirmar" do
    get :confirmar
    assert_response :success
  end

  test "should get recusar" do
    get :recusar
    assert_response :success
  end

end
