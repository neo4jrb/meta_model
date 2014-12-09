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

      redirect_to action: :edit
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

