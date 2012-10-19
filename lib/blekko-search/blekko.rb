class Blekko
  HOST = "blekko.com"
  DEFAULT_MAX_FREQUENCY_PER_SECOND = 1
  SECURE_PROTOCOL = "https://"
  NON_SECURE_PROTOCOL = "http://"
      
  attr_accessor :protocol, :api_key, :max_frequency_per_second, :username, :password, :login_cookie
      
  def initialize(args={})
    @api_key = args[:api_key]
    @protocol = args[:secure] ? SECURE_PROTOCOL : NON_SECURE_PROTOCOL
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
    URI("#{SECURE_PROTOCOL}#{HOST}/login?u=#{CGI.escape(username)}&p=#{CGI.escape(password)}&auth=#{api_key}")
  end
  
  def headers
    { 
      "Cookie" => login_cookie,
      "User-Agent" => "blekko-search-#{BlekkoSearch::VERSION}"
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
