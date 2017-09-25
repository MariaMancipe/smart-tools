class Video < ApplicationRecord
  belongs_to :concurso
  mount_uploader :video, VideoUploader
  before_save :mark_state

  def mark_state
    self.estado ||= 0
  end
  #Validations
end
