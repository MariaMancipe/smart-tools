class ConcursosController < ApplicationController

  before_action :set_usuario, only: [:indexUsuario, :showUsuario, :create, :update, :destroy]
  before_action :set_usuario_concurso, only: [:showUsuario, :update, :destroy]

  # GET /concursos
  def index
    @concursos = Concurso.all
    json_response(@concursos)
  end

  #GET /concursos/usuario/:usuario_id
  def indexUsuario
    json_response(@usuario.concursos)
  end

  #GET /concursos/:id
  def show
    @concurso = Concurso.find(params[:id])
    json_response(@concurso)
  end

  #GET /concursos/usuario/:usuario_id/:id
  def showUsuario
    json_response(@concurso)
  end

  #POST /concursos/usuario/:usuario_id
  def create
    @usuario.concursos.create!(concurso_params)
    json_response(@usuario.concursos, :created)
  end

  #UPDATE /concursos/usuario/:usuario_id/:id
  def update
    @concurso.update(concurso_params)
    head :no_content
  end

  #DELETE /concursos/usuario/:usuario_id/:id
  def destroy
    @concurso.destroy
    head :no_content
  end

  private

  def concurso_params
    params.permit(:nombre, :fecha_inicio, :fecha_fin, :url, :descripcion, :usuario_id, :picture)
  end

  def set_usuario
    @usuario = Usuario.find(params[:usuario_id])
  end

  def set_usuario_concurso
    @concurso = @usuario.concursos.find_by!(id: params[:id]) if @usuario
  end
end
