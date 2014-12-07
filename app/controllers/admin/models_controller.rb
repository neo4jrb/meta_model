module Admin
  class ModelsController < ApplicationController
    def index
      @models = Model.all
    end
  end
end

