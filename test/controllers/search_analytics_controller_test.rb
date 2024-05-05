require "test_helper"

class SearchAnalyticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @search_analytic = search_analytics(:one)
  end

  test "should get index" do
    get search_analytics_url
    assert_response :success
  end

  test "should get new" do
    get new_search_analytic_url
    assert_response :success
  end

  test "should create search_analytic" do
    assert_difference("SearchAnalytic.count") do
      post search_analytics_url, params: { search_analytic: { ip_address: @search_analytic.ip_address, query: @search_analytic.query } }
    end

    assert_redirected_to search_analytic_url(SearchAnalytic.last)
  end

  test "should show search_analytic" do
    get search_analytic_url(@search_analytic)
    assert_response :success
  end

  test "should get edit" do
    get edit_search_analytic_url(@search_analytic)
    assert_response :success
  end

  test "should update search_analytic" do
    patch search_analytic_url(@search_analytic), params: { search_analytic: { ip_address: @search_analytic.ip_address, query: @search_analytic.query } }
    assert_redirected_to search_analytic_url(@search_analytic)
  end

  test "should destroy search_analytic" do
    assert_difference("SearchAnalytic.count", -1) do
      delete search_analytic_url(@search_analytic)
    end

    assert_redirected_to search_analytics_url
  end
end
