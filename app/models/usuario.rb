class Usuario < ApplicationRecord
  has_many :concursos, dependent: :destroy

  #validations
end
