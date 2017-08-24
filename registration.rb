require 'capybara'
require 'faker'
require 'capybara/dsl'
require 'json'
require "selenium-webdriver"

Capybara.run_server = false
Capybara.current_driver = :selenium

module AccountCreator
  include Capybara::DSL

  @data = {'username': "", 'password': "", 'email': ""}

  def generate_credentials
    @data['username'] = Faker::Internet.user_name(6..10) + ((1..999).to_a).sample.to_s
    @data['password'] = Faker::Internet.password(8) 
    @data['email'] =  @data['username'] + '@mailinator.com'
  end

  def visit_email
    visit('https://www.mailinator.com/v2/inbox.jsp')
    fill_in 'inbox_field', :with => @data['username']
    page.find('#inbox_button').click 
    sleep 1 
  end

  def confirm_email
    AccountCreator::visit_email    
    page.first("div", :text => "Подтверждение аккаунта").click 
    sleep 1
    within_frame 'msg_body' do find(:link, 'подтвердить').click end
    sleep 3
  end

  def output
    puts @data['username'] + ':' + @data['password']
  end

  def fill_credentials
    fill_in 'user[username]', :with => @data['username']
    fill_in 'user[email]', :with => @data['email']
    fill_in 'user[password]', :with => @data['password']
    fill_in 'user[password_confirmation]', :with => @data['password']
  end

  def register
    visit('https://dev.by/registration')
    AccountCreator::fill_credentials
  	check('user_agreement')
  	click_button "Зарегистрироваться"
  end

  def new_account
    AccountCreator::generate_credentials
    AccountCreator::register
    AccountCreator::confirm_email
    Capybara.current_session.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  end
end

include AccountCreator
amount = ARGV[0].to_i
amount.times do
  AccountCreator::new_account
  AccountCreator::output
end


