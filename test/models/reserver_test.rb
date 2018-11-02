require 'test_helper'

class ReserverTest < ActiveSupport::TestCase
  def setup
    @reserver = reservers(:john)
    @reserver.email_address_confirmation=@reserver.email_address
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
