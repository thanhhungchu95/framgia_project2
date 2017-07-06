class Ability
  include CanCan::Ability

  def initialize user
    if user
      can :read, :all
      can [:edit, :update], User, id: user.id
      can :create, Post
    else
      cannot :read, User
      can :read, Post
      cannot [:create, :edit, :update], :all
    end
  end
end
