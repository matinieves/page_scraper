require "rails_helper"

RSpec.describe PageElement do
  subject(:element) { FactoryGirl.build(:page_element, page: nil) }

  it 'should belong to a page' do
    expect(element).to_not be_valid
    expect(element.errors.full_messages).to include('Page can\'t be blank')
  end

  describe '#save_for_page' do
    let!(:page) { FactoryGirl.create(:page) }

    let(:response) do
      instance_double(
        "Net::HTTPResponse",
        code: Scraper::SUCCESS,
        body: file_fixture("h1.txt").read
      )
    end

    before do
      allow(Scraper::RequestClient).to receive(:get).with(page.url).and_return(response)
    end

    it 'should create a PageElement' do
      expect { PageElement.save_for_page(page) }.to change { PageElement.count }.by(1)
    end

    it 'should create a PageElement for the given page' do
      PageElement.save_for_page(page)
      expect(PageElement.last.page_id).to eq page.id
    end

    it 'should create a PageElement with the correct type' do
      PageElement.save_for_page(page)
      expect(PageElement.last.h1?).to be_truthy
    end

    it 'should create a PageElement with the correct content' do
      PageElement.save_for_page(page)
      expect(PageElement.last.content).to eq 'H1 tag'
    end

    it 'should create a PageElement with the correct attributes' do
      PageElement.save_for_page(page)
      expect(PageElement.last.element_attributes).to eq({ 'class' => 'class-1' })
    end
  end
end
