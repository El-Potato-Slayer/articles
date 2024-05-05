class AddEmailToSearchAnalytics < ActiveRecord::Migration[7.1]
  def change
    add_column :search_analytics, :email, :string
  end
end
