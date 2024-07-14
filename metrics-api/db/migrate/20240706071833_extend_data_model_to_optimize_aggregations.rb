class ExtendDataModelToOptimizeAggregations < ActiveRecord::Migration[6.1]
  def change
    add_column :metrics, :minute_precision, :datetime
    add_column :metrics, :hour_precision, :datetime
    add_column :metrics, :day_precision, :datetime
    add_index :metrics, [:name, :minute_precision]
    add_index :metrics, [:name, :hour_precision]
    add_index :metrics, [:name, :day_precision]
    add_index :metrics, [:name, :created_at]
    add_index :metrics, [:name, :value, :timestamp], unique: true, name: 'unique_index_metrics_on_name_value_and_timestamp'
    
    create_table :aggregated_metrics do |t|
      t.string :name, null: false
      t.integer :period, null: false
      t.datetime :timestamp, null: false
      t.decimal :average_value, precision: 10, scale: 2
      t.decimal :min_value, precision: 10, scale: 2
      t.decimal :max_value, precision: 10, scale: 2
      t.decimal :total_value, precision: 10, scale: 2
      t.integer :count

      t.timestamps
    end

    add_index :aggregated_metrics, [:name, :period, :timestamp], unique: true, name: 'index_aggregated_metrics_on_name_and_period_and_timestamp'

    create_table :aggregation_states do |t|
      t.string :name, null: false
      t.integer :period, null: false
      t.datetime :last_aggregated_at, null: false

      t.timestamps
    end

    add_index :aggregation_states, [:name, :period], unique: true, name: 'index_aggregation_states_on_name_and_period'
  end
end
