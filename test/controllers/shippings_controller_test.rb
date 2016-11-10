require 'test_helper'

class ShippingsControllerTest < ActionController::TestCase

  test "that find_rate returns an error message when no weight is passed through the params" do
    get :find_rate, {"origin_zip" => "10001", "dest_zip" => "98100"}
    assert_response :bad_request
  end

  test "that find_rate returns an error message when no origin_zip is passed through the params" do
    get :find_rate, {"weight" =>"100", "dest_zip" => "98100"}
    assert_response :bad_request
  end

  test "that find_rate returns an error message when no destination zip is passed through the params" do
    get :find_rate, {"origin_zip" => "10001", "weight" => "100"}
    assert_response :bad_request
  end

  test "that find_rate returns shipping rate" do
    get :find_rate, {"weight" => "100", "origin_zip" => "10001", "dest_zip" => "98100"}
    body = JSON.parse(response.body)

    assert_instance_of Array, body
    assert_equal ["name", "cost"], body.map(&:keys).flatten.uniq

    assert_response :ok
  end
end
