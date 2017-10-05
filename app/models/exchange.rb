# Exchange record
class Exchange < ApplicationRecord
  validates :base, :target, presence: true
  validates :amount, numericality: { only_float: true, greater_than: 0 }
  validates :weeks, inclusion: { in: 1..250 },
                    numericality: { greater_than: 0, less_than: 26 }
end
