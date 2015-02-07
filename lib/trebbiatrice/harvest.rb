#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Trebbiatrice
  class Harvest
    def initialize(login_data)
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
end
