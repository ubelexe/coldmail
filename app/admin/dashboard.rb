ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel t(:letters_graph) do
          render partial: 'graph'
        end
      end
    end
  end
end
