class HTMLProcessor
  attr_accessor :elements

  def initialize(response, page)
    @page = page
    @html = Nokogiri::HTML(response)
    @elements = []
  end

  def extract_content
    PageElement.element_types.keys.each { |type| element_content(type) }
  end

  private

  def element_content(element_type)
    @html.css(element_type).each do |node|
      element = {}
      element[:element_type] = element_type
      element[:content] = encode_value(node.text)
      extract_attributes(element, node)
      @elements << element
    end
  end

  def extract_attributes(element, node)
    attrs = node.attributes
    element[:element_attributes] = attrs.update(attrs){|key,value| node_value(value) }
  end

  def node_value(node)
    node.is_a?(String) ? encode_value(node) : encode_value(node.value)
  end

  def encode_value(value)
    value.encode!('UTF-8', 'UTF-8', :invalid => :replace)
  end
end
