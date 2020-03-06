require './lib/omni_auth/strategies/microsoft_graph'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :microsoft_graph,
           ENV['AZURE_APP_ID'],
           ENV['AZURE_APP_SECRET'],
           scope: ENV['AZURE_SCOPES']
end
