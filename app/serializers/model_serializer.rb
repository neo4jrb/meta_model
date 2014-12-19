class ModelSerializer < ActiveModel::Serializer
  attributes :id, :class_name

  has_many :properties
end
