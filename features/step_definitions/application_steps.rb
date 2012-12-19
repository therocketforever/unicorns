Given /^I am on the Home Page$/ do
    visit "/"
end

Then /^I should see "(.*?)" is the title of the page$/ do |text|
    page.should have_xpath("//title", :text => text)
end
