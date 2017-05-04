class PageElement < ApplicationRecord
  serialize :element_attributes, Hash
  enum element_type: [:h1, :h2, :h3, :link]

  belongs_to :page

  validates :page, presence: true
end