class CreateConcursos < ActiveRecord::Migration[5.1]
  def change
    create_table :concursos do |t|
      t.string :nombre
      t.datetime :fecha_inicio
      t.datetime :fecha_fin
      t.string :url
      t.string :descripcion
      t.references :usuario, foreign_key: true

      t.timestamps
    end
  end
end
