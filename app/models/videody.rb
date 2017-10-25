
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



  belongs_to :concurso ,:class => Concursody

  field :created_at, :datetime, {default: ->(){Time.now}}

end