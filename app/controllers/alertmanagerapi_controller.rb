class AlertmanagerapiController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:catch]
    accept_api_auth :catch
   
    def catch
        project = Project.find_by_name(Setting.plugin_alertmanager['settings_project'])
        user = User.find_by_mail(Setting.plugin_alertmanager['settings_user'])
        tracker = project.trackers.find_by_name(Setting.plugin_alertmanager['settings_tracker'])
        priority = IssuePriority.find_by_name(Setting.plugin_alertmanager['settings_priority'])
        params[:alerts].each do |k,v|
            id = "#{k["labels"]["alertname"]} #{k["labels"]["instance"]} #{k["fingerprint"]}"
            if k["status"] == "firing" and Issue.where(:subject => id).any? == false 
                status = IssueStatus.find_by_name(k["status"])
                issue = Issue.new(
                    :author => user,
                    :project => project,
                    :tracker => tracker,
                    :priority => priority,
                    :status => status,
                )
                issue.subject = id
                issue.description = "*Alertname* : #{k["labels"]["alertname"]} \n\n *Instance* : #{k["labels"]["instance"]} \n\n *Description* : #{k["annotations"]["description"]} \n\n *Generator* : #{k["generatorURL"]} \n\n *Starts At* : #{k["startsAt"]}"
                issue.save
            end

            if k["status"] == "firing" and Issue.where(:subject => id).any? == true and Issue.where(:status => IssueStatus.find_by_name("resolved")).any? == true
                issue = Issue.where(:subject => id, :status => IssueStatus.find_by_name("resolved"))
                issue.update(:status => IssueStatus.find_by_name("firing"))
            end
            
            if k["status"] == "resolved" and Issue.where(:subject => id).any? == true and Issue.where(:status => IssueStatus.find_by_name("firing")).any? == true
                issue = Issue.where(:subject => id, :status => IssueStatus.find_by_name("firing"))
                issue.update(:status => IssueStatus.find_by_name("resolved"))
            end
        end
        render :json => "Succeeded !"
    end
end
