module Meta
  class AssociationsController < ApplicationController
    def index
      @has_associations = HasAssociation.all
    end

  end
end

