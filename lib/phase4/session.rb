require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
      cookie = cookie.value unless cookie.nil?
      cookie ||= "{}"
      @session = JSON::parse(cookie)
    end

    def [](key)
      @session[key]
    end

    def []=(key, val)
      @session[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies ||= []
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @session.to_json)
    end
  end
end
