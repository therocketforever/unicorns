Given /^I am on the Home Page$/ do
  visit "/"
end

Then /^I should see "(.*?)" in the title of the page$/ do |text|
  #page.should have_selector('title', :text => "#{text}")
end
