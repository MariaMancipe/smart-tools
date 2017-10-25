class VideosController < ApplicationController
  before_action :set_concurso
  before_action :set_concurso_video, only: [:show, :update, :destroy]

  # GET /videos
  def all
    @videos = Videody.all
    json_response(@videos)
  end

  # GET /videos/byConcurso/:concurso_id
  def index
    json_response(@concurso.videos)
  end

  # GET /videos/:id
  def show
    @video = Videody.find(params[:id])
    json_response(@video)
  end

  # POST /videos/concurso/:concurso_id
  def create
    #@concurso.videos.create!(video_params)

    @video = Videody.new(video_params)
    @concurso.videos.create(video_params)
    @video.concurso = @concurso
    @video.save
    json_response(@concurso.videos, :created)
  end

  # PUT /concursos/:concurso_id/videos/:id
  def update
    @video.update(video_params)
    head :no_content
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
