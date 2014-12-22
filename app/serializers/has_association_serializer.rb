class HasAssociationSerializer < ActiveModel::Serializer
  attributes :id, :join_type, :name, :opposite_name, :relationship_type

end

