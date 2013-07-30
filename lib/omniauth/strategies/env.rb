# Based on code from the oa-env gem

require 'omniauth'
require 'omniauth-ldap/adaptor'

module OmniAuth
  module Strategies
    class Env
      include OmniAuth::Strategy

      def request_phase
        @user_data = {}
        @uid = env['HTTP_REMOTE_USER']
        return fail![:no_user] unless @uid

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

        filter = Net::LDAP::Filter.eq('cn', @uid)
        adaptor.connection.search(base: @options[:base], filter: filter) do |entry|
          @user_data[:name] = "#{entry.givenname.first} #{entry.sn.first}"
          @user_data[:email] = entry.mail.first
        end
      end
    end
  end
end
