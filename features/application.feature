Feature: Application Integrity & Enviroment
  In order to validate the integrity & runtime enviroment of this application
  As a Developer
  I want to test the integrity & runtime enviroment of this applicatios

  Scenario: Visit the Home Page
    Given I am on the Home Page
    Then I should see "therocketforever" in the title of the page
