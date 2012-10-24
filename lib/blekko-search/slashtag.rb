class Blekko
  class Slashtag
    
    attr_accessor :name, :blekko, :urls
        
    def initialize(blekko, name, args={})
      args = { eager_load: true }.merge(args)
      @blekko = blekko
      @name = name
      @urls = *args[:urls]
      if args[:eager_load] && urls.empty?
        self.urls = saved_urls
      end
    end
    
    def urls
      @urls ||= []
    end
    
    def saved_urls
      url = blekko.protocol + blekko.host + "/tag/view?name=" + CGI.escape(name) + "&format=text&auth=#{blekko.api_key}"
      lines = open(url, blekko.headers).collect { |line| line.strip }
      unless lines.first.scan(" ").any?
        lines.collect { |line| line }
      end
    end
        
    def save!
      begin
        if create!.read =~ /already exists/
          update!
        end
        true
      rescue
        false      
      end
    end
    
    def remove_urls!(*target_urls)
      blekko.request(remove_url(target_urls))
      true
    end

    
    def create!
      blekko.request(save_url("create"))
    end
    
    def update!
      blekko.request(save_url("update"))      
    end
    
    def save_url(method, target_urls=urls)
      blekko.protocol + blekko.host + "/tag/add?name=#{name}&submit=#{method}&urls=#{urls.join("%0A")}&auth=#{blekko.api_key}"
    end
    
    def remove_url(target_urls)
      blekko.protocol + blekko.host + "/tag/edit?submit=1&type=del&name=#{name}&urls=#{target_urls.join("%0A")}&auth=#{blekko.api_key}"
    end
    
    def delete_url
      blekko.protocol + blekko.host + "/tag/delete?submit=1&name=#{name}&auth=#{blekko.api_key}"
    end
    
    def delete!
      return ArgumentError, "This is not implemented by blekko yet"
      blekko.reqeust(delete_url)
    end
        
  end
end