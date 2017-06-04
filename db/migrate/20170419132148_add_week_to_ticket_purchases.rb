class AddWeekToTicketPurchases < ActiveRecord::Migration
  class TmpTicketPurchase < ActiveRecord::Base
    self.table_name = 'ticket_purchases'
  end

  def change
    add_column :ticket_purchases, :week, :integer

    TmpTicketPurchase.reset_column_information
    TmpTicketPurchase.find_each do |purchase|
      if purchase.created_at
        purchase.week = purchase.created_at.strftime('%W')
      else
        purchase.week = 0
      end
      purchase.save!
    end
  end
end
