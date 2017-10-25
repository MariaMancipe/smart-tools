class UsuariosController < ApplicationController
  #before_action :set_usuario, only: [:show, :update, :destroy]

  #GET /usuarios

  def index
    @usuarios = Usuariody.all
    json_response(@usuarios)
  end

  #POST /usuarios
  def create
    print usuario_params
    @usuario = Usuariody.new(usuario_params)
    @usuario.save
    json_response(@usuario, :created)
  end

  #GET /usuarios/:id
  def show
    @usuario = Usuariody.find(params[:id])
    json_response(@usuario)
  end

  #GET /usuarios/credenciales
  def showCredentials
    @usuario = Usuario.find_by!(correo: params[:correo], clave: params[:clave])
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
    params.permit(:nombre, :apellido, :correo, :empresa, :clave).to_h
  end

  def credenciales_params
    params.permit(:correo, :clave)
  end

  def set_usuario
    @usuario = Usuario.find(params[:id])
  end
end
