module Trebbiatrice
  class << self
    def run!(login_data, task, testata, frequency)
      trebbia = Trebbia.new(login_data)
      last_project, project = nil

      loop do
        response = Trebbia.invoke!(testata[:engine], testata[:name])

        trebbia.working_on = response[:contents].select do |content|
          trebbia.working_on = content
          trebbia.active_projects.any?
        end.last

        if response[:status] == 'failure' || !trebbia.working_on
          if trebbia.tracking?
            p "stopping #{trebbia.project[:name]}" if trebbia.project
            trebbia.stop_tracking!
          end

          last_project = nil
        else
          if trebbia.working_on && (last_project != trebbia.working_on || !trebbia.project)
            trebbia.project = trebbia.active_projects.last
            trebbia.track! task

            last_project = trebbia.working_on
            p "tracking #{trebbia.project[:name]}"
          end
        end

        sleep frequency
      end
    end
  end
end
