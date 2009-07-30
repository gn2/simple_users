class User < ActiveRecord::Base
  include AASM
  state_machine_history
  acts_as_authentic
  is_paranoid

  attr_accessible :name, :login, :email, :password, :password_confirmation, :notes

  # Validations
  validates_presence_of :name

  # Relationships

  # AASM configuration
  aasm_column :state
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :active, :enter => :do_activate
  aasm_state :inactive, :enter => :do_inactivate
  aasm_state :banned
  aasm_state :deleted, :enter => :do_delete

  aasm_event :activate do
    transitions :to => :active, :from => [:pending, :inactive]
  end
  aasm_event :inactivate do
    transitions :to => :inactive, :from => [:passive, :pending, :verified, :active, :deleted, :banned]
  end
  aasm_event :ban do
    transitions :to => :banned, :from => [:passive, :pending, :verified, :active, :inactive, :deleted]
  end
  aasm_event :remove_ban do
    transitions :to => :active, :from => [:banned]
  end
  aasm_event :delete do
    transitions :to => :deleted, :from => [:passive, :pending, :verified, :active, :inactive, :banned]
  end
  aasm_event :restore do
    transitions :to => :inactive, :from => [:deleted]
  end

  def do_activate
    @activated = true
    update_attributes(:deleted_at => nil, :perishable_token => nil)
  end
  
  def do_inactivate
    update_attribute(:deleted_at, nil)
  end
  
  def do_delete
    update_attribute(:deleted_at, Time.now)
  end

  # Some methods used by observers
  def recently_activated?
    @activated
  end

  # Instance nethods
  def is_admin?
    self.is_admin
  end
  
  def admin!
    update_attribute(:is_admin, true)
  end
  
  def revoke_admin!
    update_attribute(:is_admin, false)
  end
  # Class methods

end
