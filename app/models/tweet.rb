class Tweet < ApplicationRecord
  # 画像も空では投稿できないように設定（追加実装・エラ〜メッセージ日本語化）
  validates :text, :image, presence: true

  belongs_to :user
  has_many :comments

  # 発展カリキュラムで下記の記述をサービスクラスに書き出している【app/services/search_tweets_service.rb】

  # def self.search(search)
  #   if search != ""
  #     Tweet.where('text LIKE(?)', "%#{search}%")
  #   else
  #     Tweet.all
  #   end
  # end
end
