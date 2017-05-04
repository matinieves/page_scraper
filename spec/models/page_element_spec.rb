require "rails_helper"

RSpec.describe PageElement do
  subject(:element) { FactoryGirl.build(:page_element, page: nil) }

  it 'should belong to a page' do
    expect(element).to_not be_valid
    expect(element.errors.full_messages).to include('Page can\'t be blank')
  end
end
