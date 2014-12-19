class Model < MetaModelBase
  property :class_name, type: String

  has_one :out, :superclass_model, type: :inherits_from, model_class: 'Model'

  has_one :out, :id_property, type: :has_id_property, model_class: '::Property'
  has_many :out, :properties, type: :has_property

  has_many :both, :assocs, model_class: 'Model', rel_class: 'HasAssociation'

  def to_param
    self.class_name.tableize
  end

#  def property_ids
#    properties(:p).pluck(p: :uuid)
#  end

  def self.hierarchically
    Hash.new.tap do |result|
      model_parents = Hash[*all.query_as(:model).optional_match("model-[:inherits_from]->(parent)").pluck(:model, :parent).flatten]

      all.query_as(:model).where('NOT(model-[:inherits_from]->())').pluck(:model).each do |model|
        result[model] = {}
      end

      all.query_as(:model).match('p=model-[:inherits_from*1..]->()').pluck('nodes(p)').each do |path|
        path.reverse.inject(result) do |sub_result, model|
          sub_result[model] ||= {}
          sub_result[model]
        end
      end

    end
  end
end
