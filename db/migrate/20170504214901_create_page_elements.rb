class CreatePageElements < ActiveRecord::Migration[5.1]
  def change
    create_table :page_elements do |t|
      t.integer :page_id
      t.integer :element_type
      t.string  :element_attributes
      t.string  :content
    end
  end
end
