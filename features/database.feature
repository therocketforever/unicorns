Feature: Database Opperation & Integrety
  As a Developer
  In order to verify Database Functionality & Model Integrity
  I want to validate Model Relationships & Database Integrity

  Scenario: Create an Article WITHOUT embeded images
     Given I have Agency
      When I create an "Article"
      Then I should be able to load the "Article" from the Database

  Scenario: Create an Image
     Given I have Agency
      When I create an "Image"
      Then I should be able to load the "Image" from the Database

  Scenario: Create an Article WITH embeded images
     Given I have Agency
       And I can create an "Article"
      When I create an "Article" with an EmbededImage
      Then I should be able to load the "Article" from the Database
       And I should be able to load the Article's EmbededImage(s)
