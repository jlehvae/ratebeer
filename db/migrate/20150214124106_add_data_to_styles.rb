class AddDataToStyles < ActiveRecord::Migration
  def up
    styles = Beer.all.collect {|b| b.old_style}.uniq

    styles.each do |s|
      Style.create(name: s, description: "#{s} description")
    end
  end

  def down
    Style.delete_all
  end
end
