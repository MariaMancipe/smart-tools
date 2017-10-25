class ConcursosController < ApplicationController

  before_action :set_usuario, only: [:indexUsuario, :showUsuario, :create, :update, :destroy]
  #before_action :set_usuario_concurso, only: [:showUsuario, :update, :destroy]

  # GET /concursos
  #CHECK
  def index
    @concursos = Concursody.all
    json_response(@concursos)
  end

  #GET /concursos/usuario/:usuario_id
  #CHECK
  def indexUsuario
    json_response(@usuario.concursos)
  end

  #GET /concursos/:id
  #CHECK
  def show
    @concurso = Concursody.find(params[:id])
    json_response(@concurso)
  end

  #GET /concursos/usuario/:usuario_id/:id
  def showUsuario
    json_response(@concurso)
  end

  #POST /concursos/usuario/:usuario_id
  def create
    @concurso = Concursody.new(concurso_params)
    @concurso.save
    @usuario.concursos.create(concurso_params)
    @concurso.usuario = @usuario
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
    params.permit(:nombre, :fecha_inicio, :fecha_fin, :url, :descripcion, :usuario_id, :picture).to_h
  end

  def set_usuario
    @usuario = Usuariody.find(params[:usuario_id])
  end

  def set_usuario_concurso
    @concurso = @usuario.concursos.find(params[:id]) if @usuario
  end
end
