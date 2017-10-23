require './app/queuer/uploadqueuer'

class Video < ApplicationRecord
  belongs_to :concurso
  mount_uploader :video, VideoUploader
  before_save :mark_state
  after_save :send_to_queue

  def mark_state
    self.estado ||= 0
  end

  def send_to_queue
    UploaderQueuer::send_message_to_converter_queue('New video uploaded!', self.id, self.video_original, self.correo_concursante)
  end
  #Validations
end
