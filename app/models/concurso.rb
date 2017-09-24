class Concurso < ApplicationRecord
  belongs_to :usuario

  has_many :videos, dependent: :destroy

  #Validations
end
