class UsuariosController < ApplicationController
  #before_action :set_usuario, only: [:show, :update, :destroy]

  #GET /usuarios

  def index
    @usuarios = Usuariody.all
    json_response(@usuarios)
  end

  #POST /usuarios
  def create
    # print usuario_params
    # Usuario.create!(usuario_params)
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
    @usuario = Usuariody.where(correo: params[:correo], clave: params[:clave]).all
    json_response(@usuario)
  end

  #PUT /usuarios/:id
  def update
    @usuario = Usuariody.find(params[:id])
    @usuario.update_attributes(usuario_params)
    json_response(@usuario)
  end

  #DELETE /usuarios/:id
  def destroy
    @usuario = Usuariody.find(params[:id])
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
