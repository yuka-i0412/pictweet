class Tweet < ApplicationRecord
  validates :text, presence: true
  # textカラムにデータの制約をかける（データが空なら保存できない）
  belongs_to :user
  has_many :comments

end
