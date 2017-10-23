class Concursody
  include Dynamoid::Document

  table :name => :concurso, :key => :id, :read_capacity => 40, :write_capacity => 40

  field :nombre
  field :fecha_inicio
  field :fecha_fin
  field :url
  field :descripcion
  field :picture

  belongs_to :usuario ,:class => Usuariody
  #has_many :video ,:class => Videody

  field :created_at, :datetime, {default: ->(){Time.now}}


end