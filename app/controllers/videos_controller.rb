class VideosController < ApplicationController
  before_action :set_concurso, only: [:index, :create]
  #before_action :set_concurso_video, only: [:show, :update, :destroy]

  # GET /videos
  #CHECK
  def all
    @videos = Videody.all
    json_response(@videos)
  end

  # GET /videos/concurso/:concurso_id
  #CHECK
  def index
    json_response(@concurso.videos)
  end

  # GET /videos/:id
  #CHECK
  def show
    @video = Videody.find(params[:id])
    json_response(@video)
  end

  # POST /videos/concurso/:concurso_id
  def create
    #@concurso.videos.create!(video_params)

    @video = Videody.new(video_params)
    @video.save
    @concurso.videos.create(video_params)
    @video.concurso = @concurso

    json_response(@concurso.videos, :created)
  end

  # PUT /videos/:id
  def update
    @video = Videody.find(params[:id])
    @video.update_attributes(video_params)
    json_response(@video)
  end

  #GET /videos/:concurso_id/estado/:estado
  def estado
    search_estado
    json_response(@videos_estado)
  end



  private

  def video_params
    params.permit(:nombre, :duracion, :nombre_concursante, :apellido_concursante, :correo_concursante, :mensaje_concursante, :fecha_carga, :video, :estado, :concurso_id).to_h
  end

  def set_concurso
    @concurso = Concursody.find(params[:concurso_id])
  end

  def search_estado
    @videos_estado = @concurso.videos.find_by!(estado: params[:estado]) if @concurso
  end

  def set_concurso_video
    @video = @concurso.videos.find(params[:id]) if @concurso
  end
end
