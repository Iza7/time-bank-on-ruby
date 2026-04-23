ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

BCrypt::Engine.cost = BCrypt::Engine::MIN_COST

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors, with: :threads)
    fixtures :all
  end
end

module ActionDispatch
  class IntegrationTest
    def sign_in(user, password: "password123")
      post "/login", params: { email: user.email, password: password }
    end

    def sign_in_as_admin
      sign_in(users(:admin), password: "adminpass1")
    end
  end
end
