class ModelsController < ApplicationController
  before_action :get_model
  before_action :get_meta_model

  def meta_index
    @models = Model.order(:class_name)
  end

  def index
    @records = @model.all.to_a
  end

  def show
    @record = @model.find(params[:id])
  end

  def edit
    @record = @model.find(params[:id])
  end

  private

  def get_meta_model
    @meta_model = Model.where(class_name: model_param_class_name).first if model_param_class_name
  end

  def get_model
    @model = model_param_class_name.constantize if model_param_class_name
  end

  def model_param_class_name
    if params[:model]
      @model_param_class_name ||= params[:model].classify
    end
  end
end


