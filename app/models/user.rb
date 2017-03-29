# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  firstname       :string
#  lastname        :string
#  admin           :boolean
#

class User < ApplicationRecord
	has_secure_password

	validates :email, presence: true, email: true, uniqueness: true
	validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create
	validates :firstname, presence: true
	validates :lastname, presence: true
	validates :admin, boolean: true
end
