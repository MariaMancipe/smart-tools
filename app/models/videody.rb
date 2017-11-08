
class Videody
  include Dynamoid::Document

  table :name => :video, :key => :id, :read_capacity => 40, :write_capacity => 40

  field :nombre
  field :duracion
  field :fecha_carga
  field :estado
  field :nombre_concursante
  field :apellido_concursante
  field :correo_concursante
  field :mensaje_concursante
  field :video_convertido
  field :video_original
  field :video
  field :created_at, :datetime, {default: ->(){Time.now}}


  belongs_to :concurso ,:class => Concursody

  after_save :send_to_queue

  def send_to_queue
    puts 'ID del video'
    puts self.video
    UploaderQueuer::send_message_to_converter_queue('New video uploaded!', self.id, self.video, self.correo_concursante)
  end
end