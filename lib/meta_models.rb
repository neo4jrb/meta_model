
models = Model.query_as(:model).match("p=model-[:inherits_from*0..]-()").order("max(length(p))").pluck(:model, 'max(length(p))').map(&:first)


models.each do |model|
  code = "class #{model.class_name}"
  code << " < #{model.superclass_model.class_name}" if model.superclass_model
  code << "\n"

  code << "  include Neo4j::ActiveNode\n"
  code << "  include ModelBase\n"


  model.properties.each do |property|
    code << "  property :#{property.name}, type: #{property.type}\n"
  end

  model.assocs.each do |assoc|
    options = {type: assoc.type, model_class: assoc.model_class, origin: assoc.origin}
    code << "  has_#{assoc.has} :#{assoc.direction}, :#{assoc.name}, #{options.inspect}\n"
  end

  code << "end"

  puts "code", code
  eval(code)
end
