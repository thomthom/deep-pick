require 'sketchup.rb'

module TT::Plugins::DeepPick

  unless file_loaded?(__FILE__)
    cmd_deep_pick_tool = UI::Command.new('Deep Pick') {
      self.deep_pick_tool
    }.tap { |cmd|
      cmd.tooltip = 'Deep Pick'
    }

    menu = UI.menu('Tools')
    menu.add_item(cmd_deep_pick_tool)

    toolbar = UI::Toolbar.new(EXTENSION[:name])
    toolbar.add_item(cmd_deep_pick_tool)
    toolbar.restore

    file_loaded(__FILE__)
  end

  def self.deep_pick_tool
    Sketchup.active_model.select_tool(DeepPickTool.new)
  end


  class DeepPickTool

    # @param [Integer] flags
    # @param [Integer] x
    # @param [Integer] y
    # @param [Sketchup::View] view
    def onLButtonDown(flags, x, y, view)
      ph = view.pick_helper(x, y)
      active_path = view.model.active_path || []
      path = ph.path_at(0)
      puts 'onLButtonDown'
      p view.model.active_path
      p path
      if view.model.active_path
        if path
          path = view.model.active_path + path
        else
          path = view.model.active_path
          path.pop
        end
      end
      view.model.active_path = path
    end

    # @param [Integer] flags
    # @param [Integer] x
    # @param [Integer] y
    # @param [Sketchup::View] view
    def onLButtonDoubleClick(flags, x, y, view)
      view.model.active_path = nil
    end

    # @param [Integer] reason
    # @param [Sketchup::View] view
    def onCancel(reason, view)
      if reason == 0 # ESC
        view.model.active_path = nil
      end
    end

  end

  # load 'tt_deep_pick/main.rb'

end # module
