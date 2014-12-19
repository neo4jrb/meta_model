module Meta
  class ModelsController < ApplicationController
    before_action :get_model, only: [:edit, :show, :update, :destroy]

    def index
      respond_to do |format|
        format.html { @hierarchy = Model.all.hierarchically }
        format.json { render json: Model.all.to_a }
      end
    end

    def hierarchy
      respond_to do |format|
        format.json { render json: Model.all.hierarchically }
      end
    end

    def show
      respond_to do |format|
        format.json do
          render json: @model
        end
      end
    end

    def edit
      @models = Model.all.order(:name)
    end

    def update
      @model.class_name = params[:model_data][:class_name]
      @model.superclass_model = Model.where(class_name: params[:model_data][:superclass_model]).first
      @model.save

      # Properties
      specified_property_names = []
      (params[:model_data][:properties] || []).each do |property_params|
        name = property_params[:name]
        specified_property_names << name

        (@model.properties.where(name: name).first || Property.new(name: name, model: @model)).tap do |property|
          property_params.each do |attribute, value|
            property.write_attribute(attribute, value)
          end
        end.save
      end
      @model.properties(:property).query.where("NOT(property.name IN {names})").params(names: specified_property_names).pluck(:property).each(&:destroy)


      redirect_to action: :edit, model: @model
    end

    def update
      logger.warn "model_params: #{model_params}"
      @model.update(model_params)

      render json: @model
    end

    def destroy
      @model.destroy

      render json: nil
    end

    private

    def get_model
      @model = Model.where(class_name: model_param_class_name).first if model_param_class_name
    end

    def model_param_class_name
      if params[:class_name]
        @model_param_class_name ||= params[:class_name].classify
      end
    end

    def model_params
      superclass_model = params[:model].delete(:superclass_model_id)
      params.require(:model).permit(:class_name).merge(superclass_model: superclass_model)
    end
  end
end

