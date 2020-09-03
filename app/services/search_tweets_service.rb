class SearchTweetsService
  def self.search_tweets(keyword)
    return Tweet.all unless keyword
    Tweet.where('text LIKE(?)', "%#{keyword}%")
  end
end