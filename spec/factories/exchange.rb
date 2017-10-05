FactoryGirl.define do
  factory :exchange, :class => 'Exchange' do
    base 'USD'
    target 'EUR'
    amount 100
    weeks 5
    avg_rate 2
  end
end