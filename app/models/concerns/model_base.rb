module ModelBase
  extend ActiveSupport::Concern

  LOADED_CLASSES = []
  included do |base|
    LOADED_CLASSES << self
  end

  module ClassMethods
    def inherited(base)
      LOADED_CLASSES << base
    end
  end

  def _description
    self.try(:name) || self.try(:description) || self.id
  end
end
