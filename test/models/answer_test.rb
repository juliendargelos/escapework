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

require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
