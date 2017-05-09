class Page < ApplicationRecord
  has_many :page_elements

  def self.find_or_create_from_url(url)
    url = URI(url).scheme.nil? ? "http://#{url}" : url

    page = Page.find_or_create_by(url: url).tap do |page|
      page.page_elements.delete_all #Previous page's elements are deleted
    end

    PageElement.save_for_page(page)
  end
end
