class Video < ApplicationRecord
  belongs_to :concurso
  mount_uploader :video, VideoUploader
  #Validations
end
