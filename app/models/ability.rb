# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new

    if user.role == 'admin' then
      can :index, AdminsController
      can :new, UsersController
      can :edit, UsersController
      can :new, ChaptersController
      can :edit, ChaptersController
    end

    if user.role == 'external' then
      can :index, FormsController
      can :new, ArrestableActionsController
      can :new, StreetSwarmsController
      can :new, TrainingsController
      can :new, GrowthActivitiesController
      can :new, SocialMediaBlitzingsController
    end
  end
end
