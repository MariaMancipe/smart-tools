class CreateUsuarios < ActiveRecord::Migration[5.1]
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :apellido
      t.string :correo
      t.string :empresa
      t.string :clave

      t.timestamps
    end
  end
end
