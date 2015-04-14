require 'json'

class User < ActiveRecord::Base
  has_many :uploaded_songs, foreign_key: "uploader_id", class_name: "Song"
  has_many :themes
  has_many :theme_songs, through: :themes, source: :song
  has_many :play_events

  scope :admins, -> {where admin: true}

  validates :nickname, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: true
  validates :provider, presence: true

  before_save :check_if_head_admin
  before_create :become_uploader #Allow new users to upload automatically for now

  def self.random
    offset(rand count).first
  end

  def self.filter attributes
    attributes.inject(self) do |scope, (key, value)|
      case key.to_sym
      when :admin
        scope.where(admin: true)
      when :banned
        scope.where("banned_at NOT NULL").order(banned_at: :desc)
      when :uploader
        scope.where(uploader: true)
      else
        scope
      end
    end
  end

  def self.create_with_steam_id(steam_id)
    return nil if steam_id.nil?

    WebApi.api_key = ENV['STEAM_API_KEY']
    json = JSON.parse(WebApi.json "ISteamUser", "GetPlayerSummaries", 2, {steamids: steam_id.to_s})
    steam = json["response"]["players"][0]
    return nil if steam.nil?

    create! do |user|
      user.provider = "steam"
      user.uid = steam["steamid"].to_s
      user.nickname = steam["personaname"]
      user.avatar_url = steam["avatarmedium"]
      user.avatar_icon_url = steam["avatar"]
    end
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.nickname = auth["info"]["nickname"]
      user.avatar_url = auth["info"]["image"]
      user.avatar_icon_url = auth["extra"]["raw_info"]["avatar"]
    end
  end

  def steam_update
    steam = SteamId.new(uid.to_i)
    update_attributes(nickname: steam.nickname, avatar_url: steam.medium_avatar_url, avatar_icon_url: steam.icon_url)
    touch
  end

  def check_for_account_update
    if updated_at < 7.days.ago
      begin
        steam_update
      rescue SteamCondenserError
      end
    end
  end

  def profile_url
    "http://steamcommunity.com/profiles/#{uid}"
  end

  def banned?
    banned_at
  end

  def to_param
    uid.parameterize
  end

  def generate_remember_me_token
    begin
      self.remember_me_token = SecureRandom.hex
    end while User.exists?(remember_me_token: remember_me_token)
  end

  private
  def check_if_head_admin
    if provider == "steam" && uid == ENV['STEAM_HEAD_ADMIN_ID']
      self.admin = true
    end
  end

  def become_uploader
    self.uploader = true
  end


end
