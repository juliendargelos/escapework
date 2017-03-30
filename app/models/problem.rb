# == Schema Information
#
# Table name: problems
#
#  id          :integer          not null, primary key
#  workshop_id :integer          not null
#  solution    :string           not null
#  kind        :integer          default(1), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Problem < ApplicationRecord
    belongs_to :workshop
    has_many :answers

    enum kind: {
        string: 1,
        number: 2,
        regexp: 3
    }

    validates :workshop, presence: true
    validates :solution, presence: true
    validates :kind, presence: true
end