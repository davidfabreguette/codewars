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

  def disable_puts_and_prints
    # Disable console outputs temporarily
    RSpec::Mocks.with_temporary_scope do
      %w(puts print).each do |p_cmd|
        allow_any_instance_of(CodeWars::Launcher).to receive(p_cmd.to_sym)
        .and_return(true)
      end
    end
  end
end
