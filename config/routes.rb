# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

post '/alertmanagerapi', :to => 'alertmanagerapi#catch', :as => "catch"
