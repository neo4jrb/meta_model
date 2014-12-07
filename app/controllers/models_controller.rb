class ModelsController < ApplicationController
  before_action :get_model

  def index
  end

  def show
    @record = @model.find(params[:id])
  end

  def edit
    @record = @model.find(params[:id])
  end

  private

  def get_model
    class_name = params[:model].classify
    @meta_model = Model.where(class_name: class_name).first
    @model = class_name.constantize
  end
end


