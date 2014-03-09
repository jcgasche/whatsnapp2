include ApplicationHelper


def authentication_test_prepare_with_valid_info
	let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
	return :user
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

def user_test_prepare_with_valid_info
	before do
		fill_in "Name",         with: "Example User"
		fill_in "Email",        with: "user@example.com"
		fill_in "Password",     with: "foobar"
		fill_in "Confirmation", with: "foobar"
	end
end

def user_test_prepare_after_saving_user
	before { click_button submit }
	let(:user) { User.find_by(email: 'user@example.com') }
	return :user
end

