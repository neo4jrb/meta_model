class HasAssociation
  include Neo4j::ActiveRel

  from_class Model
  to_class Model
  type 'has_association_to'


  # one_to_many refers to from_class has_many to_classes
  # many_to_one refers to from_class has_one  to_class
  property :join_type, type: String
  validates_inclusion_of :join_type, :in => %w( many_to_one one_to_many many_to_many )

  # Name of associations on each side
  property :name, type: String
  property :opposite_name, type: String

  property :relationship_type, type: String

end
