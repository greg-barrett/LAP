require 'test_helper'

class ReserverTest < ActiveSupport::TestCase
  def setup
    @reserver = Reserver.new(first_name: "John", last_name: "Smith", email_address: "j.smith@gmail.com", email_address_confirmation: "j.smith@gmail.com",
       id_type: "Passport", id_number: "5874589658s", contact_number: "+44 7707302785", title: "Mr",
     house_number: "01 01 01", street_name: "Cliff Street", city: "Sheffield", country: "Spain", postcode: "BL0 0RY")
     @reserver2=Reserver.new
   end

   test "should be valid" do
     assert @reserver.valid?
   end

   test "all fields should be filled" do
     assert_not @reserver2.valid?
   end

   test "title should be present" do
     @reserver.title="   "
     assert_not @reserver.valid?
   end

   test "id_type should be present" do
     @reserver.id_type="   "
     assert_not @reserver.valid?

   end
   test "id number should be present" do
     @reserver.id_number="   "
     assert_not @reserver.valid?
   end

   #email validitity

   test "email validation should accept valid addresses" do
     valid_emails= %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
        valid_emails.each do |email|
          @reserver.email_address = email
          @reserver.email_address_confirmation = email
          assert @reserver.valid?, "#{email.inspect} should be valid"
        end
    end

    test "invalid email addresses should be invalid" do
      invalid_emails= %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
      invalid_emails.each do |email|
        @reserver.email_address= email
        @reserver.email_address_confirmation = email
        assert_not @reserver.valid?, "#{email.inspect}, shouln't be valid"
      end
    end
end
