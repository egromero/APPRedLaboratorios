require "application_system_test_case"

class LaboratoriesTest < ApplicationSystemTestCase
  setup do
    @laboratory = laboratories(:one)
  end

  test "visiting the index" do
    visit laboratories_url
    assert_selector "h1", text: "Laboratories"
  end

  test "creating a Laboratory" do
    visit laboratories_url
    click_on "New Laboratory"

    fill_in "Campus", with: @laboratory.campus
    fill_in "Facultad", with: @laboratory.facultad
    fill_in "Nombre", with: @laboratory.nombre
    click_on "Create Laboratory"

    assert_text "Laboratory was successfully created"
    click_on "Back"
  end

  test "updating a Laboratory" do
    visit laboratories_url
    click_on "Edit", match: :first

    fill_in "Campus", with: @laboratory.campus
    fill_in "Facultad", with: @laboratory.facultad
    fill_in "Nombre", with: @laboratory.nombre
    click_on "Update Laboratory"

    assert_text "Laboratory was successfully updated"
    click_on "Back"
  end

  test "destroying a Laboratory" do
    visit laboratories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Laboratory was successfully destroyed"
  end
end
