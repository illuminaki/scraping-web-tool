require "application_system_test_case"

class SentEmailsTest < ApplicationSystemTestCase
  setup do
    @sent_email = sent_emails(:one)
  end

  test "visiting the index" do
    visit sent_emails_url
    assert_selector "h1", text: "Sent emails"
  end

  test "should create sent email" do
    visit sent_emails_url
    click_on "New sent email"

    fill_in "Body", with: @sent_email.body
    fill_in "Email", with: @sent_email.email
    fill_in "Message", with: @sent_email.message_id
    fill_in "Register", with: @sent_email.register_id
    fill_in "Status", with: @sent_email.status
    fill_in "Subject", with: @sent_email.subject
    click_on "Create Sent email"

    assert_text "Sent email was successfully created"
    click_on "Back"
  end

  test "should update Sent email" do
    visit sent_email_url(@sent_email)
    click_on "Edit this sent email", match: :first

    fill_in "Body", with: @sent_email.body
    fill_in "Email", with: @sent_email.email
    fill_in "Message", with: @sent_email.message_id
    fill_in "Register", with: @sent_email.register_id
    fill_in "Status", with: @sent_email.status
    fill_in "Subject", with: @sent_email.subject
    click_on "Update Sent email"

    assert_text "Sent email was successfully updated"
    click_on "Back"
  end

  test "should destroy Sent email" do
    visit sent_email_url(@sent_email)
    accept_confirm { click_on "Destroy this sent email", match: :first }

    assert_text "Sent email was successfully destroyed"
  end
end
