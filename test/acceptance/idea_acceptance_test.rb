ENV['RACK_ENV'] = 'test'
require_relative 'acceptance_helper'

class IdeaAcceptanceTest < Minitest::Test
  include Capybara::DSL

  def setup
  end

  def teardown
    IdeaStore.delete_all
  end

  def test_creates_an_idea
    visit '/'
    fill_in("idea[title]",:with => "mobile app")
    fill_in("idea[description]",:with => "very cool mobile app")
    fill_in("idea[tags]",:with => "tech")
    click_button("submit")
    assert page.has_content?("mobile")
  end
end
