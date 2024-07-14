class CreateMetrics < ActiveRecord::Migration[5.1]
    def change
      create_table :metrics do |t|
        t.string :name, null: false
        t.decimal :value, precision: 10, scale: 2, null: false
        t.datetime :timestamp, default: -> { 'CURRENT_TIMESTAMP' }

        t.timestamps
      end
    end
  end
