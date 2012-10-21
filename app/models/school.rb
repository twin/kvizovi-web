# encoding: utf-8
require_relative "school/example_quiz"

class School < ActiveRecord::Base
  has_many :students, dependent: :destroy
  has_many :quizzes, dependent: :destroy
  has_many :questions, through: :quizzes

  has_secure_password

  validates_presence_of :name, :level, :username, :key, :place, :region, :email
  validates_presence_of :password, on: :create
  validates_uniqueness_of :username

  def to_s
    name
  end

  def grades
    primary? ? (1..8) : (1..4)
  end

  def primary?
    level == "Osnovna"
  end

  def secondary?
    level == "Srednja"
  end

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password])
  end
end
