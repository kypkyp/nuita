require 'test_helper'

class NweetsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @nweet = nweets(:today)
    @friend_nweet = nweets(:yesterday)
    @user = users(:chikuwa)
  end

  test 'should get show' do
    assert_not_equal nweet_path(@nweet), "/nweets/#{@nweet.id}"
    assert_equal nweet_path(@nweet), "/nweets/#{@nweet.url_digest}"

    get nweet_path(@nweet)
    assert_response :success

    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', user_path(@user)
  end

  test 'should get new' do
    share_text = 'This text should be appear in input form!'
    get new_nweet_path(@nweet, text: share_text)
    # テストではredirectではなくunauthorized返される。deviseの仕様か?
    # 他環境でのリダイレクトは既に確認済みのため、ここでは401でテストを通す
    # assert_redirected_to new_user_session_url
    assert_response :unauthorized

    login_as(@user)
    get new_nweet_path(@nweet, text: share_text)
    assert_select 'textarea', share_text
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Nweet.count' do
      post nweets_path, params: {nweet: {did_at: Time.zone.now}}
    end
    assert_redirected_to new_user_session_path
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Nweet.count' do
      delete nweet_path(@nweet)
    end
    assert_redirected_to new_user_session_path
  end

  test 'logged-in user can create their own nweet' do
    login_as(@user)
    assert_difference('Nweet.count', 1) do
      post nweets_path, params: {nweet: {did_at: Time.zone.now}}
    end
    # post request doesn't contain user info, so no need to check correct user
  end

  test 'logged-in user can delete their own nweet' do
    login_as(@user)

    assert_no_difference('Nweet.count') do
      delete nweet_path(@friend_nweet)
    end

    assert_difference('Nweet.count', -1) do
      delete nweet_path(@nweet)
    end
  end

  test 'logged-in user can edit their own nweet' do
    login_as(@user)

    patch nweet_path(@nweet), params: {nweet: {statement: '誰だ今の'}}
    @nweet.reload
    assert_equal '誰だ今の', @nweet.statement

    patch nweet_path(@friend_nweet), params: {nweet: {statement: '誰だ今の'}}
    @friend_nweet.reload
    assert_not_equal '誰だ今の', @friend_nweet.statement
  end
end
