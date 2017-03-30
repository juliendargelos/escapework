# == Schema Information
#
# Table name: workshops
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Workshop < ApplicationRecord
	has_many :problems
	has_many :partipations

	validates :name, presence: true
end
