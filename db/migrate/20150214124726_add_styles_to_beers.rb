class AddStylesToBeers < ActiveRecord::Migration
  def up
    Style.all.each do |s|
      Beer.all.each do |b|
        s.name == b.old_style ? b.style = s : false
        b.save
      end
    end
  end

  def down
    Beer.all.each do |b|
      b.style = nil
      b.save
    end
  end
end
