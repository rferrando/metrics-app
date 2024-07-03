class CreateMetrics < ActiveRecord::Migration[5.1]
    def change
      create_table :metrics do |t|
        t.string :name
        t.numeric :value
        t.datetime :timestamp, default: -> { 'CURRENT_TIMESTAMP' }

        t.timestamps
      end
    end
  end
