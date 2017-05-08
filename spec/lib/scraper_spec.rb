require "rails_helper"

RSpec.describe Scraper do
  let(:response) do
    instance_double(
      "Net::HTTPResponse",
      code: Scraper::SUCCESS,
      body: file_fixture("h1.txt").read
    )
  end

  before do
    allow(Scraper::RequestClient).to receive(:get).with(url_with_protocol).and_return(response)
  end

  describe 'when the given page is a new page' do
    let(:url_with_protocol) { 'http://example.com' }
    let(:url_without_protocol) { 'example.com' }

    describe 'when the url has protocol' do
      it 'should create a new page' do
        expect { Scraper.process_page(url_with_protocol) }.to change { Page.count }.by(1)
      end
    end

    describe 'when the url has not protocol' do
      it 'should create a new page' do
        # The before block checks that the url has protocol
        expect { Scraper.process_page(url_without_protocol) }.to change { Page.count }.by(1)
      end
    end
  end

  describe 'when the given page already exist' do
    let!(:page) { FactoryGirl.create(:page) }
    let(:url_with_protocol) { page.url }

    describe 'when the url has protocol' do
      it 'should create a new page' do
        expect { Scraper.process_page(url_with_protocol) }.to_not change { Page.count }
      end
    end
  end
end
