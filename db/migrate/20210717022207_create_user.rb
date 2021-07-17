class CreateUser < ActiveRecord::Migration[6.1]

  def change
    # https://www.postgresql.org/docs/9.1/citext.html
    execute 'CREATE EXTENSION citext;'

    create_table :users do |t|
      t.string :name, null: false
      t.citext :email, null: false, unique: true
      t.string :encrypted_password, null: false
      t.timestamps
    end
  end

end
