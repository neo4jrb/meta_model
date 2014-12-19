class ModelSerializer < ActiveModel::Serializer
  attributes :id, :class_name

  has_many :properties
  has_one :superclass_model
end
