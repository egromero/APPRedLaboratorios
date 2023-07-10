class Ability
  include CanCan::Ability

    def initialize(user)
      can :create, [Student, Record, Visit]
      can :created_from_totem, Student
      can :get_occupation, Record
      if user.present?  # additional permissions for logged in users (they can manage their posts)
      can :previous_records, Laboratory
      can :manage, [Student, Record]
        can :read, :all
      if user.rol == "admin"  # additional permissions for administrators
          can :manage, :all
      end
      end
  end
end