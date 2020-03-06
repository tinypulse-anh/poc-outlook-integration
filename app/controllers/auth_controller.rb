class AuthController < ApplicationController
  def callback
    data = request.env['omniauth.auth']
    session[:current_user] = {
      name: data.dig(:extra, :raw_info, :displayName),
      email: data.dig(:extra, :raw_info, :mail) || data.dig(:extra, :raw_info, :userPrincipalName),
      credentials: data.dig(:credentials).deep_symbolize_keys,
    }

    redirect_to root_url
  end

  def sign_out
    reset_session

    redirect_to root_url
  end
end
