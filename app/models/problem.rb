# == Schema Information
#
# Table name: problems
#
#  id          :integer          not null, primary key
#  workshop_id :integer          not null
#  name        :string           not null
#  content     :text             not null
#  solution    :string           not null
#  kind        :integer          default("string"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Problem < ApplicationRecord
    belongs_to :workshop
    has_many :answers, dependent: :destroy

    has_attached_file :image, styles: { normal: '1000x>', thumb: '100x100#' }, default_url: '/default/problem/image.svg'

    enum kind: {
        string: 1,
        number: 2,
        regexp: 3
    }

    validates :workshop, presence: true
    validates :solution, presence: true
    validates :content, presence: true
    validates :kind, presence: true

    validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/gif', 'image/png'], size: { in: 0..2.megabytes }

	def html_content
		self.content.gsub('[', '<strong>').gsub(']', '</strong>').html_safe
	end
end
