class Page < ApplicationRecord
  has_many :page_elements

  def self.find_or_create_by_url(url)
    Page.find_or_create_by(url: url).tap do |page|
      page.page_elements.delete_all #Previous page's elements are deleted
    end
  end
end
