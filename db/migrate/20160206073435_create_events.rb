class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime   :start
      t.datetime   :end
      t.references :contrib, index: true, foreign_key: true
    end
  end
end
