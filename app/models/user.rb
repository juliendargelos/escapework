# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  firstname       :string           not null
#  lastname        :string           not null
#  status          :integer          default("student"), not null
#

class User < ApplicationRecord
	has_many :participations

	has_secure_password

	enum status: {
		student: 1,
		teacher: 2
	}

	validates :email, presence: true, email: true, uniqueness: true
	validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create
	validates :firstname, presence: true
	validates :lastname, presence: true
	validates :status, presence: true

	def fullname
		self.firstname+' '+self.lastname
	end

	def participates_to? workshop
		if workshop.is_a? Workshop
			Participation.find_by(user: self, workshop: workshop) != nil
		else
			false
		end
	end
end
