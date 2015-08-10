
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
  visit new_session_path

  fill_in 'Email', with: email
  fill_in 'pod_user_password', with: password
  fill_in 'pod_user_name', with: pod_name
  fill_in 'pod_user_first_name', with: first
  fill_in 'pod_user_last_name', with: last
  select  category_name, from: 'pod_user_pod_category_id'
  click_button 'Join PodKeeper'
end

# add 'have_title' test
RSpec::Matchers::define :have_title do |text|
  match do |page|
    Capybara.string(page.body).has_selector?('title', text: text)
  end
end
