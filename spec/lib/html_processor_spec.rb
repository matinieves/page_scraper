require "rails_helper"

RSpec.describe HTMLProcessor do
  let!(:page) { FactoryGirl.create(:page) }

  subject(:processor) { HTMLProcessor.new(html, page) }

  describe 'processable element' do
    let(:html) { file_fixture("h1.txt").read }

    it 'should return a hash with the with type h1' do
      processor.extract_content
      expect(processor.elements.first[:element_type]).to eq 'h1'
    end

    it 'should return a hash with the correct content' do
      processor.extract_content
      expect(processor.elements.first[:content]).to eq 'H1 tag'
    end

    it 'should return a hash with the correct attributes' do
      processor.extract_content
      expect(processor.elements.first[:element_attributes]).to eq({ 'class' => 'class-1' })
    end
  end

  describe 'when html have elements not included in PageElement.page_element_types' do
    let(:html) { file_fixture("h5.txt").read }

    it 'should not return page elements' do
      processor.extract_content
      expect(processor.elements.count).to eq 0
    end
  end

  describe 'html with nested attributes' do
    let(:html) { file_fixture("complex_html.txt").read }

    it 'should return the expected count of page elements' do
      processor.extract_content
      expect(processor.elements.count).to eq 4
    end
  end
end
