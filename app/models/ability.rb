class Ability
  include CanCan::Ability

  def initialize user
    if user
      user_id = user.id
      can :read, :all
      can :update, User, id: user_id
      can :create, Post, Comment
      can [:update, :delete], [Post, Comment], user_id: user_id
    else
      cannot :read, User
      can :read, Post
      cannot [:create, :update], :all
    end
  end
end
