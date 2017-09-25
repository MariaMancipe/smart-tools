class Concurso < ApplicationRecord
  belongs_to :usuario

  has_many :videos, dependent: :destroy

  mount_uploader :picture, PictureUploader
  #Validations
end
