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

require 'test_helper'

class ProblemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
