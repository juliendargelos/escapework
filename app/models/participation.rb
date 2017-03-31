# == Schema Information
#
# Table name: participations
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  workshop_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Participation < ApplicationRecord
    belongs_to :user
    belongs_to :workshop

    validates :user, presence: true
    validates :workshop, presence: true

    def exists?
        participation = self.class.find_by user: self.user, workshop: self.workshop

        participation.nil? ? false : participation.id != self.id
    end
end
