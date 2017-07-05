class Ability
  include CanCan::Ability

  def initialize user
    if user
      can :read, :all
      can [:edit, :update], User, id: user.id
    else
      cannot :read, User
      cannot [:create, :edit, :update], :all
    end
  end
end
