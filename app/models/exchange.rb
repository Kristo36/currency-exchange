class Exchange < ApplicationRecord

  validates :base, :target, presence: true
  validates :amount, numericality: { only_float: true }
  validates :weeks, inclusion: { in: 1..250 }

end
