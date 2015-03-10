class Connection
  include Mongoid::Document
  field :ip, type: String
  field :identd, type: String
  field :userid, type: String
  field :datetime, type: DateTime
  field :request, type: String
  field :status, type: Integer
  field :bytes, type: Integer
  field :referrer, type: String
  field :user_agent, type: String
  field :seconds_connected, type: Integer

  validates :identd, :userid, :datetime, :request, :status, :bytes, :referrer, :user_agent, 
            :seconds_connected, presence: true
              
  validate :ip_is_valid
      
  validates :status, format: { with: /\A[1-5][0-9][0-9]\z/ }
  validates_numericality_of :bytes, :seconds_connected, greater_than_or_equal_to: 0
  
  def ip_is_valid
    errors.add(:ip, 'must be a valid ip') if (!IPAddress.valid? ip)
  end
end
