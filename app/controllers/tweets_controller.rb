class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit,:show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @tweets = Tweet.includes(:user).order("created_at DESC")
    # ビューに受け渡すために@tweetsというインスタンス変数に代入
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
    # ビューにツイート情報を受け渡す必要がないのでただの変数
    # Tweetモデルから特定のidを取り出す→削除
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
  end

  private
  # プライベートメソッド…クラス外から呼び出すことができないメソッド
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end
end


### params.require(:モデル名)　#取得したい情報を指定する
# 
# #params  #=> 中身は以下の内容
# {
#   "utf8" => "✓",
#   "authenticity_token" => "token",
#   "モデルA" => {
#     "image" => "image.jpg",
#     "text" => "sample text"
#   },
#   "commit" => "SEND",
#   "controller" => "hoges",
#   "action" => "create"
# }

# params.require(:モデルA)
# #=> { "image" => "image.jpg", "text" => "sample text" }

# params[:モデルA]  # 結果は同じだが、もしモデルAが存在しない場合はエラーになってくれない
# #=> { "image" => "image.jpg", "text" => "sample text" }

# params.require(:commit)  # モデル名以外のキーも指定できる
# #=> "SEND"

### params.require(:モデル名).permit(:キー名, :キー名)　#指定したいキーを指定する
# params.require(:post)
# #=> { "image" => "image.jpg", "text" => "sample text" }

# params.require(:post).permit(:image)  # imageのみを指定（textは取得されない）
# #=> { "image" => "image.jpg" }

# params.require(:post).permit(:image, :text)  # 指定したパラメーターだけの取得を約束する
# #=> { "image" => "image.jpg", "text" => "sample text" }
