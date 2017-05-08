require "rails_helper"

RSpec.describe HTMLProcessor do
  let!(:page) { FactoryGirl.create(:page) }

  subject(:processor) { HTMLProcessor.new(html, page) }

  describe 'processable element' do
    let(:html) { file_fixture("h1.txt").read }

    it 'it should create a new page element' do
      expect { processor.extract_content }.to change { PageElement.count }.by(1)
    end

    it 'it should create a new page element with type h1' do
      processor.extract_content
      expect(PageElement.last.h1?).to be_truthy
    end

    it 'it should create a new page element with correct content' do
      processor.extract_content
      expect(PageElement.last.content).to eq 'H1 tag'
    end

    it 'it should create a new page element with correct attributes' do
      processor.extract_content
      expect(PageElement.last.element_attributes).to eq({ 'class' => 'class-1' })
    end
  end

  describe 'when html have elements not included in PageElement.page_element_types' do
    let(:html) { file_fixture("h5.txt").read }

    it 'it should not create a new page element' do
      expect { processor.extract_content }.to_not change { PageElement.count }
    end
  end

  describe 'html with nested attributes' do
    let(:html) { file_fixture("complex_html.txt").read }

    it 'should create the expected count of page elements' do
      expect { processor.extract_content }.to change { PageElement.count }.by(4)
    end
  end
end
