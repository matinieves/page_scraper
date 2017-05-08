require 'net/http'

module Scraper
  SUCCESS = '200'

  def self.process_page(url)
    url = URI(url).scheme.nil? ? "http://#{url}" : url
    page = Page.find_or_create_by_url(url)

    response = RequestClient.get(url)

    if(response.code == SUCCESS)
      processor = HTMLProcessor.new(response.body, page)
      processor.extract_content
    else
      false
    end
  end

  module RequestClient
    def self.get(uri)
      Net::HTTP.get_response(URI(uri))
    end
  end
end
