class Ability
  include CanCan::Ability

  #:read, :create, :update, :destroy
  def initialize(user, access_token=nil)
    can :read, Directory
    can :read, Song

    #Checks for logged in users
    if user

      can :read, User, id: user.id
      can [:read, :create, :destroy], Theme, user_id: user.id

      if user.uploader? && !user.banned?
        can :create, Song
        can [:destroy, :update], Song, user_id: user.id
      end

      if user.admin?
        can :manage, :all
      end
    end

    #Checks for the api system
    if access_token && ApiKey.authenticate(access_token)
      can :manage, :api
      can :play, Song
    end

  end
end
