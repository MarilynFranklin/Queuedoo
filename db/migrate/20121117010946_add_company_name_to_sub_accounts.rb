class AddCompanyNameToSubAccounts < ActiveRecord::Migration
  def change
    add_column :sub_accounts, :company_name, :string
  end
end
