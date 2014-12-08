module ModelBase
  extend ActiveSupport::Concern

  def _description
    self.try(:name) || self.try(:description) || self.id
  end
end
