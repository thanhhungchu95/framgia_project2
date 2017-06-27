class ApplicationRecord < ActiveRecord::Base
  attr_accessible :abstract_class

  self.abstract_class = true
end
