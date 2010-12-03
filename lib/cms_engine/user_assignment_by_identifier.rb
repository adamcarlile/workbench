module CmsEngine
  module UserAssignmentByIdentifier

    # Allow user to be set by an identifier string which should contain their email address
    # AC May 2010: Refactored to search by the ID as passed by the new JSON based autocompleter

    def user_identifier
      return @instructor_user_name unless @instructor_user_name.blank?
      "#{user.name} (#{user.email})" if user
    end

    def user_identifier=(id)
      @user_id = id
      self.user = User.find(id)
    end
  
  end
end