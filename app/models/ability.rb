class Ability
  include CanCan::Ability

  def initialize user
    if user
      can :read, :all
    else
      can :read, :none
    end
  end
end
