class ConcursosController < ApplicationController

  before_action :set_usuario, only: [:indexUsuario, :showUsuario, :create]
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
    # upload_image
    # @concurso = Concursody.new(:nombre => @relacional.nombre, :fecha_inicio =>  @relacional.fecha_inicio, :fecha_fin => @relacional.fecha_fin, :descripcion => @relacional.descripcion, :picture => @relacional.picture)
    # @concurso.save
    # @usuario.concursos.create(:nombre => @relacional.nombre, :fecha_inicio =>  @relacional.fecha_inicio, :fecha_fin => @relacional.fecha_fin, :descripcion => @relacional.descripcion, :picture => @relacional.picture)
    # @concurso.usuario = @usuario

    @concurso = Concursody.new(concurso_params)
    uploader = PictureUploader.new
    uploader.store!(@concurso.picture.file)
    @concurso.save
    @usuario.concursos.create(concurso_params)

    json_response(@usuario.concursos, :created)
  end

  #UPDATE /concursos/:id
  def update

    @concurso = Concursody.find(params[:id])
    @concurso.update_attributes(concurso_params)
    json_response(@concurso)
  end

  #DELETE /concursos/usuario/:usuario_id/:id
  def destroy
    @concurso = Concursody.find(params[:id])
    @concurso.destroy
    head :no_content
  end

  private

  def upload_image
    @usuario_relacional = Usuario.find(1)
    @relacional = @usuario_relacional.concursos.new(concurso_params)
    @relacional.save
  end

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
