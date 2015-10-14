module ConfigOpenApi
  def list_new(options={})
    session_token = get_session_token
    keys = get_api_key_list(session_token)
    keys.map{|d| d['serviceName']}
  end

  def list(options={})
    call(config_open_path("list"),add_config_credentials(options))
  end

  def view(options={})
    call(config_open_path("view"),add_config_credentials(options))
  end

  def add(options={})
    call(config_open_path("add"),add_config_credentials(options))
  end

  def edit(options={})
    call(config_open_path("edit"),add_config_credentials(options))
  end

  def config_open_path(command)
    "/config/rest/pan/site/#{command}"
  end

  def add_config_credentials(options)
    options[:user]     = @user
    options[:pass] = @password

    options
  end
end
