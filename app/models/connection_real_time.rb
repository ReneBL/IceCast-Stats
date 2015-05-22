class ConnectionRealTime
  include Mongoid::Document

  field :datetime, type: DateTime
  field :listeners, type: Integer

  validates :datetime, :listeners, presence: true
                    
  validates_numericality_of :listeners, greater_than_or_equal_to: 0
end