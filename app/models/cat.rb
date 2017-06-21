class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper
  COLOR = %w(blue purple pink orange green red gray)

  validates :birth_date, :name, :description, :color, presence: true
  validates :color, inclusion: { in: COLOR, message: "Cat can't be that color" }
  validates :sex, inclusion: { in: %w(F M), message: "Sex only exists as a binary concept for cats" }

  def age
    time_ago_in_words(birth_date)
  end

  has_many :requests, dependent: :destroy,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: :CatRentalRequest
end
