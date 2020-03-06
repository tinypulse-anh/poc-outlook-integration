module OmniAuth
  module Strategies
    class MicrosoftGraph < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'openid profile email user.read'.freeze

      option :name, :microsoft_graph
      option :client_options,
             site: 'https://login.microsoftonline.com',
             authorize_url: '/common/oauth2/v2.0/authorize',
             token_url: '/common/oauth2/v2.0/token'
      option :authorize_options, [:scope]

      uid { raw_info['id'] }

      extra { { 'raw_info' => raw_info } }

      def raw_info
        @raw_info ||= access_token.get('https://graph.microsoft.com/v1.0/me').parsed
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= request.params['scope'] || DEFAULT_SCOPE
        end
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end
