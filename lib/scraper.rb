require 'net/http'

module Scraper
  SUCCESS = '200'

  def self.process_page(page)
    response = RequestClient.get(page.url)

    if(response.code == SUCCESS)
      processor = HTMLProcessor.new(response.body, page)
      processor.extract_content
      processor.elements
    else
      raise RequestClientError.new("An error ocurred while scraping the page with url #{page.url}")
    end
  end

  module RequestClient
    def self.get(uri)
      Net::HTTP.get_response(URI(uri))
    end
  end

  class RequestClientError < StandardError;  end
end
