class AddPictureToConcurso < ActiveRecord::Migration[5.1]
  def change
    add_column :concursos, :picture, :string
  end
end
