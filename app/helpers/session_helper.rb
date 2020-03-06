module SessionHelper
  def current_user
    @current_user ||= OpenStruct.new(session[:current_user]) if session[:current_user]
  end

  def signed_in?
    current_user.present?
  end

  def refresh_token(credentials)
    oauth_strategy = OmniAuth::Strategies::MicrosoftGraph.new(
      nil, ENV['AZURE_APP_ID'], ENV['AZURE_APP_SECRET'],
    )
    token = OAuth2::AccessToken.new(
      oauth_strategy.client, credentials[:token],
      refresh_token: credentials[:refresh_token]
    )
    new_token = token.refresh!
    current_user.credentials.merge!(
      token: new_token.token,
      refresh_token: new_token.refresh_token,
      expires_at: new_token.expires_at,
    )
  end

  def access_token
    credentials = current_user.credentials
    expiry = Time.at(credentials[:expires_at] - 5.minutes)

    refresh_token(credentials) if Time.current > expiry

    credentials[:token]
  end
end
