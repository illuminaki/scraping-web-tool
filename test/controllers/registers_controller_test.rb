require "test_helper"

class RegistersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @register = registers(:one)
  end

  test "should get index" do
    get registers_url
    assert_response :success
  end

  test "should get new" do
    get new_register_url
    assert_response :success
  end

  test "should create register" do
    assert_difference("Register.count") do
      post registers_url, params: { register: { address: @register.address, description: @register.description, emails: @register.emails, list_id: @register.list_id, phones: @register.phones, social_networks: @register.social_networks, title: @register.title, url: @register.url, website_url: @register.website_url } }
    end

    assert_redirected_to register_url(Register.last)
  end

  test "should show register" do
    get register_url(@register)
    assert_response :success
  end

  test "should get edit" do
    get edit_register_url(@register)
    assert_response :success
  end

  test "should update register" do
    patch register_url(@register), params: { register: { address: @register.address, description: @register.description, emails: @register.emails, list_id: @register.list_id, phones: @register.phones, social_networks: @register.social_networks, title: @register.title, url: @register.url, website_url: @register.website_url } }
    assert_redirected_to register_url(@register)
  end

  test "should destroy register" do
    assert_difference("Register.count", -1) do
      delete register_url(@register)
    end

    assert_redirected_to registers_url
  end
end
