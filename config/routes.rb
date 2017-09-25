Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #USUARIOS
  get '/usuarios' => 'usuarios#index'
  get '/usuarios/:id' => 'usuarios#show'
  post '/usuarios' => 'usuarios#create'

  #CONCURSOS
  get '/concursos' => 'concursos#index'
  get '/concursos/usuario/:usuario_id' => 'concursos#indexUsuario'
  get '/concursos/:id' => 'concursos#show'
  get '/concursos/usuario/:usuario_id/:id' => 'concursos#showUsuario'
  post '/concursos/usuario/:usuario_id' => 'concursos#create'
  patch '/concursos/usuario/:usuario_id/:id' => 'concursos#update'
  delete '/concursos/usuario/:usuario_id/:id' => 'concursos#destroy'


  #VIDEO

  get '/videos' => 'videos#all'
  get '/videos/:id' => 'videos#show'
  get '/videos/concurso/:concurso_id' => 'videos#index'
  post '/videos/concurso/:concurso_id'=>'videos#create'
  get '/videos/:concurso_id/estado/:estado' => 'videos#estado'
end
