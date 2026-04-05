require "test_helper"

class ResidencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @residence = residences(:one)
    sign_in_as @user
  end

  test "should get index" do
    get residences_url
    assert_response :success
  end

  test "should get new" do
    get new_residence_url
    assert_response :success
  end

  test "should create residence" do
    assert_difference("Residence.count") do
      post residences_url, params: { residence: { city: "Chicago", state: "IL", country: "USA", latitude: 41.8781, longitude: -87.6298 } }
    end

    assert_redirected_to residences_url
  end

  test "should render new when create is invalid" do
    assert_no_difference("Residence.count") do
      post residences_url, params: { residence: { city: "", state: "IL", country: "USA" } }
    end

    assert_response :unprocessable_content
  end

  test "should get edit" do
    get edit_residence_url(@residence)
    assert_response :success
  end

  test "should update residence" do
    patch residence_url(@residence), params: { residence: { city: "Asheville", state: "NC", country: "USA" } }

    assert_redirected_to residences_url
    assert_equal "Asheville", @residence.reload.city
  end

  test "should render edit when update is invalid" do
    patch residence_url(@residence), params: { residence: { city: "", state: "NC", country: "USA" } }

    assert_response :unprocessable_content
  end

  test "should destroy residence" do
    assert_difference("Residence.count", -1) do
      delete residence_url(@residence)
    end

    assert_redirected_to residences_url
  end
end
