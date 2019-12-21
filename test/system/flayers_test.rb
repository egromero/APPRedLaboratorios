require "application_system_test_case"

class FlayersTest < ApplicationSystemTestCase
  setup do
    @flayer = flayers(:one)
  end

  test "visiting the index" do
    visit flayers_url
    assert_selector "h1", text: "Flayers"
  end

  test "creating a Flayer" do
    visit flayers_url
    click_on "New Flayer"

    fill_in "Tittle", with: @flayer.tittle
    click_on "Create Flayer"

    assert_text "Flayer was successfully created"
    click_on "Back"
  end

  test "updating a Flayer" do
    visit flayers_url
    click_on "Edit", match: :first

    fill_in "Tittle", with: @flayer.tittle
    click_on "Update Flayer"

    assert_text "Flayer was successfully updated"
    click_on "Back"
  end

  test "destroying a Flayer" do
    visit flayers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Flayer was successfully destroyed"
  end
end
