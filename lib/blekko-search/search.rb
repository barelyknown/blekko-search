class Blekko
  class Search
    
    DEFAULT_PAGE_SIZE = 100
    DEFAULT_PAGE_NUMBER = 0
    PREFIX = "/ws/?q="
    RESPONSE_FORMAT = "/json+/"
    
    attr_accessor :query, :slashtags, :results, :blekko
    
    def initialize(blekko, query, args={})
      args = {page_size: DEFAULT_PAGE_SIZE }.merge(args)
      @blekko = blekko
      @query = query
      @slashtags = *args[:slashtags] || []
      @page_size = args[:page_size]
      @total_size = args[:total_size] || @page_size
    end
    
    def results
      @results ||= []
    end
        
    def search
      page_number = 0
      number_of_searches.times do
        response = JSON.load(open(url(page_number), blekko.headers))
        if response['RESULT']
          self.results += response['RESULT'].collect { |r| Blekko::SearchResult.new(r) }
        else
          return results
        end
        page_number += 1
      end
      results[0,@total_size]
    end
    
    def number_of_searches
      @number_of_searches ||= (@total_size.to_f / @page_size).ceil
    end
    
    def escaped_query
      CGI.escape(query + " ") + @slashtags.join("+") + "+"
    end
        
    def page_size_param
      "ps=#{@page_size}"
    end
    
    def page_number_param(page_number)
      "p=#{page_number}" if page_number > 0
    end
    
    def auth_param
      blekko.api_key ? "auth=#{blekko.api_key}" : nil
    end
    
    def params(page_number)
      [page_size_param, auth_param, page_number_param(page_number)].compact.join("&")
    end
    
    def url(page_number)
      blekko.protocol + blekko.host + PREFIX + escaped_query + RESPONSE_FORMAT + params(page_number)
    end
        
  end
end