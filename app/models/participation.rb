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
end
