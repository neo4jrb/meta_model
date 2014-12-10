class Property
  include Neo4j::ActiveNode

  property :name, type: String
  property :type, type: String

  validates_inclusion_of :type, :in => %w( String DateTime Boolean Integer )

  has_one :in, :model, origin: :properties

end

