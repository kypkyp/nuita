class Mute < ApplicationRecord
  belongs_to :muter, class_name: 'User'
  belongs_to :mutee, class_name: 'User'

  validates :muter_id, presence: true
  validates :mutee_id, presence: true
  validates_uniqueness_of :mutee_id, scope: :muter_id
end
