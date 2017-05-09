class PageElement < ApplicationRecord
  serialize :element_attributes, Hash
  enum element_type: [:h1, :h2, :h3, :a]

  belongs_to :page

  validates :page, presence: true

  def self.save_for_page(page)
    Scraper.process_page(page).each do |element_attrs|
      PageElement.create(element_attrs.merge(page: page))
    end
  end
end
