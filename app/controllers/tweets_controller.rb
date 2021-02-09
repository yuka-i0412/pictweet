class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :update, :destroy, :show]
  before_action :move_to_index, except: [:index, :new, :create, :show, :search]

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
    # 応用カリキュラムでの記載はこちら
    # Tweet.create(tweet_params)

    # 下記は追加実装のため追記（エラーメッセージ日本語化）
    @tweet = Tweet.new(tweet_params)
    #バリデーションで問題があれば、保存はされず「投稿画面」に戻る
    if @tweet.valid?
      @tweet.save
      redirect_to root_path
    else
      #保存されなければ、newに戻る
      render 'new'
    end
  end

  def destroy
    @tweet.destroy
  end

  def edit
  end

  def update
    @tweet.update(tweet_params)
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
    redirect_to action: :index unless user_signed_in?&& current_user.id == @tweet.user_id
  end
end
