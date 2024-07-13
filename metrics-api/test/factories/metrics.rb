FactoryBot.define do
    factory :metric do
      name { 'cpu' }
      value { 50 }
      timestamp { Time.now}
      minute_precision { Time.now}
      hour_precision { Time.now}
      day_precision { Time.now}
      created_at { Time.now }
      updated_at { Time.now }
    end
  end
  