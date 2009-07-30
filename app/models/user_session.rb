class UserSession < Authlogic::Session::Base
  validate :generic_error

  # Cleaning error messages, to display only a generic one
  def generic_error
    clear = false
    errors.each do |attr,message|
      if ( (attr=='login' && message=='does not exist') ||
        (attr == 'password' && message=='is not valid') )
        clear = true
      end
    end

    if clear
      errors.clear
      errors.add_to_base("Invalid login credentials")
    end
  end
end