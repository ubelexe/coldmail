ActiveAdmin.register User do
  permit_params :email, :created_at, :updated_at

    index do
      selectable_column
      id_column
      column :email
      column :current_sign_in_at
      column :last_sign_in_at
      column :current_sign_in_ip
      column :created_at
      column :updated_at
    end

    show do
      attributes_table do
        row :id
        row :email
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :created_at
        row :updated_at
      end

      panel "Email send" do
        render partial: 'form'
      end
    end

    member_action :send_email, method: :post do
      UserMailer.send_email(params[:id], params[:message]).deliver_later
      redirect_to collection_path, notice: "Email successfully sent!"
    end

end
