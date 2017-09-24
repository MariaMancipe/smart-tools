class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :update, :destroy]

  #GET /usuarios

  def index
    @usuarios = Usuario.all
    json_response(@usuarios)
  end

  #POST /usuarios
  def create
    @usuario = Usuario.create!(usuario_params)
    json_response(@usuario, :created)
  end

  #GET /usuarios/:id
  def show
    json_response(@usuario)
  end

  #PUT /usuarios/:id
  def update
    @usuario.update(usuario_params)
    head :no_content
  end

  #DELETE /usuarios/:id
  def destroy
    @usuario.destroy
    head :no_content
  end

  private

  def usuario_params
    params.permit(:nombre, :apellido, :correo, :empresa, :clave)
  end

  def set_usuario
    @usuario = Usuario.find(params[:id])
  end
end
