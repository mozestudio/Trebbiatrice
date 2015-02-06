require 'harvested'
require 'open3'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

module Trebbiatrice
  class Harvest
    def initialize
      login_data = {
        :subdomain => ENV['TREBBIA_DOMAIN']
        :username  => ENV['TREBBIA_MAIL'],
        :password  => ENV['TREBBIA_PASS']
      }

      @harvest = ::Harvest.hardy_client(login_data)
    end

    def projects
      @harvest.time.trackable_projects
    end

    def new_entry!(entry)
      @harvest.time.create(entry)
    end

    def toggle!(entry_id)
      @harvest.time.toggle(entry_id)
    end
  end

  class Trebbia
    attr_accessor :working_on

    def initialize(working_on = nil)
      @harvest     = Harvest.new
      @entry       = nil
      @tracking    = false

      if working_on
        @working_on  = working_on
        @project     = active_projects.first
      end
    end

    def get_task(name)
      @project.tasks.select { |t| t.name == name }.last
    end

    def track!(task = 'Development', notes = '')
      return if tracking?

      if @entry
        @harvest.toggle!(@entry[:id])
      else
        task_id = get_task(task)[:id]
        @entry  = @harvest.new_entry! notes: notes, hours: 0, spent_at: today, project_id: @project[:id], task_id: task_id
      end

      @tracking = true
    end

    def stop_tracking!
      if @entry && tracking?
        @tracking = false
        @harvest.toggle!(@entry[:id])
      end
    end

    def tracking?
      @tracking
    end

    def active_projects
      @harvest.projects.select { |project| /#{project[:name]}/i.match(@working_on) }
    end

    class << self
      def invoke!(*input)
        stdin, stdout, stderr = Open3.popen3(*input)

        response = unless stderr.read.chomp.strip.empty?
          { status: 'failure', contents: stderr }
        else
          { status: 'success', contents: stdout }
        end

        response[:contents] = response[:contents].read.each_line.map(&:chomp)
        response[:contents].map! { |i| i.gsub('nos', 'bugree') } # debug
        response
      end
    end

  private

    def today
      Time.now.strftime('%Y/%m/%d')
    end
  end
end

last_project = nil
project = nil
trebbia = nil
checker = Trebbiatrice::Trebbia.new

loop do
  response = Trebbiatrice::Trebbia.invoke!('osascript', 'testata.scpt')
  working_on = response[:contents].select do |content|
    checker.working_on = content
    checker.active_projects.any?
  end.last

  if response[:status] == 'failure' || !working_on
    if trebbia && trebbia.tracking?
      p "stopping #{project[:name]}" if project
      trebbia.stop_tracking!
    end

    last_project = nil
    sleep 1
  else
    if !!working_on && (last_project != working_on || !project || !trebbia)
      last_project = working_on

      trebbia = Trebbiatrice::Trebbia.new(working_on)
      trebbia.track!

      project = trebbia.active_projects.last
      p "tracking #{project[:name]}"
    end

    sleep 1
  end
end
