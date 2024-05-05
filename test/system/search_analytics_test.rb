require "application_system_test_case"

class SearchAnalyticsTest < ApplicationSystemTestCase
  setup do
    @search_analytic = search_analytics(:one)
  end

  test "visiting the index" do
    visit search_analytics_url
    assert_selector "h1", text: "Search analytics"
  end

  test "should create search analytic" do
    visit search_analytics_url
    click_on "New search analytic"

    fill_in "Ip address", with: @search_analytic.ip_address
    fill_in "Query", with: @search_analytic.query
    click_on "Create Search analytic"

    assert_text "Search analytic was successfully created"
    click_on "Back"
  end

  test "should update Search analytic" do
    visit search_analytic_url(@search_analytic)
    click_on "Edit this search analytic", match: :first

    fill_in "Ip address", with: @search_analytic.ip_address
    fill_in "Query", with: @search_analytic.query
    click_on "Update Search analytic"

    assert_text "Search analytic was successfully updated"
    click_on "Back"
  end

  test "should destroy Search analytic" do
    visit search_analytic_url(@search_analytic)
    click_on "Destroy this search analytic", match: :first

    assert_text "Search analytic was successfully destroyed"
  end
end
