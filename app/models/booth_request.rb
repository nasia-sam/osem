class BoothRequest < ActiveRecord::Base
  belongs_to :booth
  belongs_to :user

  validates :role,
            presence: true

  ROLES = %w[submitter responsible].freeze
end
