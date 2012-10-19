class Blekko
  class SearchResult
    attr_accessor :n_group, :display_url, :rss, :rss_title, :short_host, :short_host_url,
                  :snippet, :toplevel, :url, :url_title, :doc_date_iso, :address, :geocluster,
                  :lat, :lon, :phone, :zip, :is_robots_banned
                  
    def initialize(result)
      result.each do |key, value|
        send("#{key}=", value) if respond_to? "#{key}="
      end
    end
    
    def datetime
      DateTime.parse(doc_date_iso) if doc_date_iso
    end
    
    def toplevel
      @toplevel == "1" ? true : false
    end
    
    alias_method :sequence, :n_group
    alias_method :abstract, :snippet
    
  end
end