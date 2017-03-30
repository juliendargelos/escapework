# == Schema Information
#
# Table name: answers
#
#  id         :integer          not null, primary key
#  team_id    :integer          not null
#  problem_id :integer          not null
#  content    :string           not null
#  right      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Answer < ApplicationRecord
    belongs_to :user
    belongs_to :problem

    validates :user, presence: true
    validates :problem, presence: true
    validates :content, presence: true

    def self.for problem, user
        if problem.is_a?(Problem) && user.is_a?(User)
            attributes = { problem: problem, user: user }
            answer = self.find_by attributes
            answer = self.create attributes if answer.nil?

            answer
        else
            nil
        end
    end

    def right
        case self.answer.kind
        when :number
            answer.content.to_f == self.content.to_f
        when :string
            answer.content == self.content
        when :regexp
            answer.content.to_regexp =~ self.content
        else
            false
        end
    end
end
