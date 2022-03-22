Redmine::Plugin.register :alertmanager do
  name 'Alertmanager plugin'
  author 'Jules Delecour'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/davidson-consulting/redmine-alertmanager-plugin.git'
  author_url 'https://github.com/davidson-consulting'
  settings default: {'empty' => true}, partial: 'settings/alertmanagerapi_settings'
  project_module :alertmanagerapi do
    permission :create_alert, {:alertmanagerapi => [:catch]}, :require => :member
  end
end