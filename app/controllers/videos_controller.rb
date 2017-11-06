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
    uploader = VideoUploader.new
    video = File.new(video_params[:video].path)
    s3_path = "https://s3.amazonaws.com/smart-tools-new/uploads/videos/uploads/"
    s3_path_convertido = "https://s3.amazonaws.com/smart-tools-new/uploads/videos/converted/"
    path = s3_path + File.basename(video_params[:video].path)
    path_convertido =  s3_path_convertido + File.basename(video_params[:video].path, File.extname(video_params[:video].path))+ ".mp4"
    @video = Videody.new(:nombre => video_params[:nombre] ,:duracion => video_params[:duracion] ,:nombre_concursante=> video_params[:nombre_concursante], :apellido_concursante => video_params[:apellido_concursante], :correo_concursante => video_params[:correo_concursante], :mensaje_concursante => video_params[:mensaje_concursante], :estado => video_params[:estado], :video => path, :video_original => path, :video_convertido => path_convertido)
    uploader.store!(video)
    @video.save
    @concurso.videos.create(:nombre => video_params[:nombre] ,:duracion => video_params[:duracion] ,:nombre_concursante=> video_params[:nombre_concursante], :apellido_concursante => video_params[:apellido_concursante], :correo_concursante => video_params[:correo_concursante], :mensaje_concursante => video_params[:mensaje_concursante], :estado => video_params[:estado], :video => path, :video_original => path, :video_convertido => path_convertido)

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
