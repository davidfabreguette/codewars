module LauncherHelpers
  def get_launcher_with_no_output
    launcher = nil
    # Disable console outputs temporarily
    RSpec::Mocks.with_temporary_scope do
      CodeWars::Launcher.disable_auto_start!
      launcher = CodeWars::Launcher.instance
    end

    launcher
  end
end
