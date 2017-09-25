class Video < ApplicationRecord
  belongs_to :concurso
  mount_uploader :video, VideoUploader
  before_save :mark_state

  def mark_state
    puts self.video
    self.estado ||= 1
  end
  #Validations
end
