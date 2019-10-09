require 'sketchup.rb'

module TT::Plugins::DeepPick

  ICON_PATH = File.join(__dir__, 'icons').freeze
  ICON_EXT = Sketchup.platform == :platform_win ? 'svg' : 'pdf'

  # @param [String] basename
  # @return [String]
  def self.icon(basename)
    File.join(ICON_PATH, "#{basename}.#{ICON_EXT}")
  end

  # @param [UI::Command]
  # @param [String] basename
  def self.set_icon(command, basename)
    command.small_icon = self.icon(basename)
    command.large_icon = self.icon(basename)
  end

  unless file_loaded?(__FILE__)
    cmd_deep_pick_tool = UI::Command.new('Deep Pick') {
      self.deep_pick_tool
    }.tap { |cmd|
      cmd.tooltip = 'Deep Pick'
      self.set_icon(cmd, 'deep-pick')
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
