Given /^I have Agency$/ do
  @agent = Agent.new
  @agent.class.should == Agent
end

When /^I create an "(.*?)"$/ do |d_obj_type|
  @d_obj = Object.const_get(d_obj_type.to_sym).create
  @d_obj.class.to_s.to_sym.should == d_obj_type.to_sym
end

Then /^I should be able to load the "(.*?)" from the Database$/ do |d_obj_type|
  DObject.get(@d_obj.id).should == @d_obj
end

Given /^I can create an "(.*?)"$/ do |d_obj_type|
  @d_obj = Object.const_get(d_obj_type.to_sym).create
  DObject.get(@d_obj.id).should == @d_obj
  DObject.get(@d_obj.id).class.should == @d_obj.class
end

When /^I create an "(.*?)" with an EmbededImage$/ do |d_obj_type|
  @d_obj = Object.const_get(d_obj_type.to_sym).create
  @embeded_image = @d_obj.embeded_images.create
end

Then /^I should be able to load the Article's EmbededImage\(s\)$/ do
  DObject.get(@d_obj.images.first.id).should == @embeded_image
end
