
def sign_in(user)
  visit signin_path
  within("#signin-form") do
    fill_in 'email',    with: user.email
    fill_in 'password', with: user.password
    click_button 'Sign In'
  end
end

def sign_out
  page.driver.submit :delete, "/sessions/1", {}
end

def sign_out_js(user)
  find('#user_controls').hover
  click_link 'Sign Out'
end

def sign_up_with(email, password, first, last, pod_name, category_name)
  visit signup_path

  fill_in 'Enter Your Email Address', with: email
  fill_in 'Choose Password', with: password
  # fill_in 'pod_user_name', with: pod_name
  fill_in 'First Name', with: first
  fill_in 'Last Name', with: last
  # select  category_name, from: 'pod_user_pod_category_id'
  click_button 'Sign Up for my Free Account'
end

# add 'have_title' test
RSpec::Matchers::define :have_title do |text|
  match do |page|
    Capybara.string(page.body).has_selector?('title', text: text)
  end
end
