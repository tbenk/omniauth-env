# Based on code from the oa-env gem

require 'omniauth'
require 'omniauth-ldap/adaptor'

module OmniAuth
  module Strategies
    class Env
      include OmniAuth::Strategy

      def env_user
        if env['HTTP_REMOTE_USER'] && env['HTTP_REMOTE_USER'] != ''
          env['HTTP_REMOTE_USER']
        else
          env['HTTP_X_FORWARDED_USER']
        end
      end

      def request_phase
        @user_data = {}
        return fail!(:no_user) unless env_user

        @uid = env_user.gsub(/@.*/, '')

        fill_ldap_info unless @options.empty?

        @env['omniauth.auth'] = auth_hash
        @env['REQUEST_METHOD'] = 'GET'
        @env['PATH_INFO'] = "#{OmniAuth.config.path_prefix}/#{name}/callback"

        call_app!
      end

      uid { @uid }
      
      info { @user_data }

      private

      def fill_ldap_info
        adaptor = OmniAuth::LDAP::Adaptor.new @options

        filter = Net::LDAP::Filter.eq('samAccountName', @uid)
        adaptor.connection.search(base: @options[:base], filter: filter) do |entry|
          @user_data[:name] = "#{entry.givenname.first} #{entry.sn.first}"
          @user_data[:email] = entry.mail.first
        end
      end
    end
  end
end
