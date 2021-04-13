module ConfLoad

  # load configuration / secret from file
  def load_conf_file(config_name)
    path = File.expand_path "~/.#{CONF_FILE_PREFIX}_#{config_name}"
    if File.exists? path
      conf = File.read path
      conf.strip
    else
      raise "ConfigFileNotFound - #{config_name.inspect} - You need to create a file named `#{File.basename path}` in ~/ containing your secret or specify the env var #{config_name.upcase}"
    end
  end

end
