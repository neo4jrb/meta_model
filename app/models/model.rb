class Model
  include Neo4j::ActiveNode

  property :class_name, type: String

  has_one :out, :superclass_model, type: :inherits_from, model_class: 'Model'

  has_one :out, :id_property, type: :has_id_property, model_class: 'Property'
  has_many :out, :properties, type: :has_property

  has_many :out, :assocs, type: :has_association, model_class: 'Assoc'
end
