class Alert < ActiveRecord::Base
    unloadable
    belongs_to :project
end