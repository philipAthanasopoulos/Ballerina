require "application_system_test_case"

class ShootoutsTest < ApplicationSystemTestCase
  setup do
    @shootout = shootouts(:one)
  end

  test "visiting the index" do
    visit shootouts_url
    assert_selector "h1", text: "Shootouts"
  end

  test "should create shootout" do
    visit shootouts_url
    click_on "New shootout"

    click_on "Create Shootout"

    assert_text "Shootout was successfully created"
    click_on "Back"
  end

  test "should update Shootout" do
    visit shootout_url(@shootout)
    click_on "Edit this shootout", match: :first

    click_on "Update Shootout"

    assert_text "Shootout was successfully updated"
    click_on "Back"
  end

  test "should destroy Shootout" do
    visit shootout_url(@shootout)
    click_on "Destroy this shootout", match: :first

    assert_text "Shootout was successfully destroyed"
  end
end
