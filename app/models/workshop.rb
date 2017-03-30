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
	has_many :problems, dependent: :destroy
	has_many :participations, dependent: :destroy

	validates :name, presence: true

	def plural_participants?
		self.participations.length > 1
	end

	def participants
		self.participations.length.to_s
	end
end
