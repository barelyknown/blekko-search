class Blekko
  HOST = "www.blekko.com"
  DEFAULT_MAX_FREQUENCY_PER_SECOND = 1
      
  attr_accessor :protocol, :api_key, :max_frequency_per_second, :username, :password, :login_cookie
      
  def initialize(args={})
    @api_key = args[:api_key]
    @protocol = args[:secure] ? "https://" : "http://"
    @username = args[:username]
    @password = args[:password]
    @max_frequency_per_second = args[:max_frequency_per_second] || DEFAULT_MAX_FREQUENCY_PER_SECOND
    login if @api_key && @username && @password
  end
  
  def host
    HOST
  end
  
  def search(query, args={})
    Blekko::Search.new(self, query, args).search
  end
  
  def slashtag(name, args={})
    Blekko::Slashtag.new(self, name, args)
  end
  
  def login_uri
    URI("https://blekko.com/login?u=#{CGI.escape(username)}&p=#{CGI.escape(password)}&auth=#{api_key}")
  end
  
  def headers
    { 
      "Cookie" => "A=AfGTtGoSio7Hnc1xiaSrwkJX4ggMfcFiBXufPUPQXZvB5TRe36Q6tPI4woK6SKO8%2Bh8qeD7z0qEk%2B4Ceg5N9HA95UTpznKUvuuEfb04GiwhAlKARpLnp18%2BI6EYQfes1PB0QNnhHwEAC3kLjyJqCZbsxVw8ud4Z6F%2Fbg6BvJj28L;",
      "User-Agent" => "Ruby"
    }
  end
  
  def login
    raise ArgumentError, "Username and password are required" unless username && password
    Net::HTTP.start(login_uri.host, login_uri.port, use_ssl: true) do |http|
      response = http.request Net::HTTP::Get.new login_uri.request_uri
      self.login_cookie = response.get_fields('Set-Cookie').find { |c| c =~ /\AA=/ }
    end
  end
  
  
end
