module Admin
  class ModelsController < ApplicationController
    before_action :get_model, only: [:edit, :update]

    def index
      @models = Model.all
    end

    def edit
    end

    def update
      @model.class_name = params[:model_data][:class_name]
      @model.save

      specified_property_name = []
      params[:model_data][:properties].each do |property_params|
        name = property_params[:name]
        specified_property_name << name

        (@model.properties.where(name: name).first || Property.new(name: name, model: @model)).tap do |property|
          property_params.each do |attribute, value|
            property.write_attribute(attribute, value)
          end
        end.save
      end

      @model.properties(:property).query.where("NOT(property.name IN {names})").params(names: specified_property_name).pluck(:property).each(&:destroy)

      redirect_to action: :edit, model: @model
    end

    private

    def get_model
      @model = Model.where(class_name: model_param_class_name).first if model_param_class_name
    end

    def model_param_class_name
      if params[:model]
        @model_param_class_name ||= params[:model].classify
      end
    end
  end
end

