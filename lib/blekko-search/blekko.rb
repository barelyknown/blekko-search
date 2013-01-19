class Blekko
  HOST = "blekko.com"
  DEFAULT_MAX_FREQUENCY_PER_SECOND = 1
  SECURE_PROTOCOL = "https://"
  NON_SECURE_PROTOCOL = "http://"

  class << self
    attr_accessor :last_request_at
    def last_request_at
      @last_request_at ||= {}
    end
  end

  attr_accessor :protocol, :api_key, :max_frequency_per_second, :username, :password, :login_cookie, :headers

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

  def web_url(query)
    Blekko::Search.new(self, query).web_url
  end

  def slashtag(name, args={})
    Blekko::Slashtag.new(self, name, args)
  end

  def request(url)
    sleep(seconds_until_next_request)
    self.last_request_at = Time.now
    open(url, headers)
  end

  def login_uri
    URI("#{SECURE_PROTOCOL}#{HOST}/login?u=#{CGI.escape(username)}&p=#{CGI.escape(password)}&auth=#{api_key}")
  end

  def headers
    @headers ||= { "User-Agent" => "blekko-search-#{BlekkoSearch::VERSION}" }
  end

  def login
    raise ArgumentError, "Username and password are required" unless username && password
    Net::HTTP.start(login_uri.host, login_uri.port, use_ssl: true) do |http|
      response = http.request Net::HTTP::Get.new login_uri.request_uri
      self.login_cookie = response.get_fields('Set-Cookie').find { |c| c =~ /\AA=/ }
      headers["Cookie"] = login_cookie
      headers["User-Agent"] = "blekko-search-#{BlekkoSearch::VERSION}"
    end
  end

  def delay_between_requests
    1 / max_frequency_per_second.to_f
  end

  def last_request_at
    self.class.last_request_at[api_key]
  end

  def last_request_at=(value)
    self.class.last_request_at[api_key] = value
  end

  def earliest_next_request
    last_request_at ? last_request_at + delay_between_requests : Time.now
  end

  def seconds_until_next_request
    [earliest_next_request - Time.now, 0].max
  end

end
