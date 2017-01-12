require 'omniauth'
require 'rbsso/client'

module OmniAuth
  module Strategies
    class SSO
      include OmniAuth::Strategy

      args [:service_id, :client_key]
      option :fields, [:name, :email]
      option :uid_field, :email

      SSO_URL = 'neststaging.riseup.net/sso_auth'

      def request_phase
        redirect authorize_url(options.authorize_params)
      end

      uid do
        info_from_ticket[options.uid_field]
      end

      info do
        info_from_ticket.slice *options.fields
      end

      def authorize_url(_params_from_options)
        params = { s: options.service_id }
        "https://#{SSO_URL}/?" + params.to_param
      end

      def name
        'ai_sso'
      end

      def info_from_ticket
        @info_from_ticket ||= client.open request["t"]
      end

      def client
        RbSSO::Client.new options.client_key
      end
    end
  end
end
OmniAuth.config.add_camelization "sso" , "SSO"
