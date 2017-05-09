require "rails_helper"

RSpec.describe PageElement do
  before do
    allow(Scraper).to receive(:process_page)
    allow(PageElement).to receive(:save_for_page)
  end

  let(:url_with_protocol) { 'http://example.com' }
  let(:url_without_protocol) { 'example.com' }

  describe '#find_or_create_from_url' do
    describe 'when there is no page with the given url' do
      it 'should create a new page' do
        expect { Page.find_or_create_from_url(url_with_protocol) }.to change { Page.count }.by(1)
      end

      describe 'when the url has protocol' do
        it 'should create a page with the correct url' do
          Page.find_or_create_from_url(url_with_protocol)
          expect(Page.last.url).to eq(url_with_protocol)
        end
      end

      describe 'when the url has not protocol' do
        it 'should create a page with the correct url' do
          Page.find_or_create_from_url(url_without_protocol)
          expect(Page.last.url).to eq(url_with_protocol)
        end
      end
    end

    describe 'when there is a page with the given url' do
      let!(:page) { FactoryGirl.create(:page, url: url_with_protocol) }

      it 'should not create a new page' do
        expect { Page.find_or_create_from_url(url_with_protocol) }.to_not change { Page.count }
      end
    end
  end
end
