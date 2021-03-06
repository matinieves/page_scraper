require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe 'GET /pages' do
    let(:page) { FactoryGirl.create(:page) }
    let!(:page_element) { FactoryGirl.create(:page_element, page: page) }
    let!(:page_element_2) { FactoryGirl.create(:page_element) }

    subject(:index_action) { get :index }

    it 'has a 200 status code' do
      index_action
      expect(response.status).to eq(200)
    end

    it 'returns the expected page' do
      index_action
      expect(JSON.parse(response.body).first['id']).to eq page.id
    end

    it 'returns the page elements' do
      index_action
      expect(JSON.parse(response.body).first['page_elements']).to eq [page_element.attributes]
    end
  end

  describe 'POST /pages' do
    let(:url) { 'http://example.com' }

    let(:scraper_response) do
      instance_double(
        "Net::HTTPResponse",
        code: Scraper::SUCCESS,
        body: file_fixture("h1.txt").read
      )
    end

    before do
      allow(Scraper::RequestClient).to receive(:get).and_return(scraper_response)
    end

    subject(:create_action) { post :create, params: { url: url }}

    it 'has a 200 status code' do
      create_action
      expect(response.status).to eq(200)
    end

    it 'should create the new page' do
      expect { create_action }.to change { Page.count }.by(1)
    end

    describe 'on success' do
      it 'it should create a new page element' do
        expect { create_action }.to change { PageElement.count }.by(1)
      end

      it 'should render the correct message' do
        create_action
        expect(JSON.parse(response.body)['message']).to eq 'Page succesfully added'
      end
    end

    describe 'on error' do
      let(:request_client_response) do
        instance_double(
          "Net::HTTPResponse",
          code: '404'
        )
      end

      before do
        allow(Scraper::RequestClient).to receive(:get).and_return(request_client_response)
      end

      it 'should render the correct message' do
        create_action
        message = "An error ocurred while scraping the page with url #{url}"
        expect(JSON.parse(response.body)['message']).to eq message
      end
    end
  end
end
