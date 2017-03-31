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

	has_attached_file :image, styles: { normal: '1000x>', medium: '200x200#', thumb: '100x100#' }, default_url: '/default/image.svg'

	validates :name, presence: true
	validates :image, presence: true

	validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/gif', 'image/png'], size: { in: 0..2.megabytes }

	def plural_participants?
		self.participations.length > 1
	end

	def participants
		self.participations.length.to_s
	end

	def right_answers_for user
		if user.participates_to?(self) || user.teacher?
			right_answers = 0
			self.problems.each { |problem| right_answers += 1 if problem.solved_by? user }

			right_answers
		else
			0
		end
	end

	def completed_by? user
		self.right_answers_for(user) == self.problems.length
	end

	def score_for user
		self.right_answers_for(user).to_s+'/'+self.problems.length.to_s
	end
end
