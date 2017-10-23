
class Usuariody
  include Dynamoid::Document

  table :name => :usuario, :key => :id, :read_capacity => 40, :write_capacity => 40
  field :nombre
  field :apellido
  field :correo
  field :empresa
  field :clave

  has_many :concursos, :class => Concursody

end