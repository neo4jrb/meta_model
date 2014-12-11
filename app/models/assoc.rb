class Assoc
  include Neo4j::ActiveNode

  property :has, type: String
  property :direction, type: String
  property :name, type: String
  property :type, type: String
  property :model_class, type: String
  property :origin, type: String

  validates_inclusion_of :has, :in => %w( one many )
  validates_inclusion_of :direction, :in => %w( in out )

  validates :model_class, presence: true

  has_one :in, :model, origin: :assocs
end
