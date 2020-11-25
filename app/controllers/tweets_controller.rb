class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit,:show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    # 下記ActiveRecordを使用したインスタンス定義
    @tweets = Tweet.includes(:user).order("created_at DESC")

    # 下記find_by_sqlメソッドを使用してSQLからデータ取得
    # query = "SELECT * FROM tweets" #SELECT <取得したいデータ> FROM <テーブル名>;でデータベースからデータを取得できる
    # @tweets = Tweet.find_by_sql(query)
  end

  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(tweet_params)
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
  end

  def edit
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  def search
    @tweets = SearchTweetsService.search_tweets(params[:keyword])
    # 発展カリキュラムでサービスクラス作成、上記の記述を追加
  end

  private
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?&& current_user.id == tweet.user_id
  end
end
