require "rails_helper"

RSpec.describe Scraper do
  before do
    allow(Scraper::RequestClient).to receive(:get).with(page.url).and_return(response)
  end

  describe '.process_page' do
    let(:page) { FactoryGirl.create(:page) }

    describe 'on success' do
      let(:response) do
        instance_double(
          "Net::HTTPResponse",
          code: Scraper::SUCCESS,
          body: file_fixture("h1.txt").read
        )
      end

      it 'should return the correct quantity of page elements' do
        expect(Scraper.process_page(page).count).to eq 1
      end
    end

    describe 'on error' do
      let(:response) do
        instance_double(
          "Net::HTTPResponse",
          code: 404
        )
      end

      it 'should raise the correct exception' do
        expect { Scraper.process_page(page) }.to raise_error(Scraper::RequestClientError)
      end
    end
  end
end
