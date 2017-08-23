class AddSwagsToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :paid, :boolean, default: false
    add_column :sponsors, :has_swag, :boolean, default: false
    add_column :sponsors, :swag_received, :boolean
    add_column :sponsors, :address, :string
    add_column :sponsors, :vat, :string
    add_column :sponsors, :has_banner, :boolean, default: false
  end
end
