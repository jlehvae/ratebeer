class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end

    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer
    # Beer.all.collect { |b| b.old_style }.uniq.each { |s| Style.create(name:s, description:s) }
    # Style.all.each {|s| Beer.all.each {|b| s.name == b.old_style ? b.style = s : false; b.save } }
  end
end
