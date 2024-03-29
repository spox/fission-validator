require 'fission-validator'

module Fission
  module Validator
    # Common methods
    module Commons

      # Load data store bits
      def setup(*_)
        require 'fission-data/init'
      end

      # Set account specific information into payload
      #
      # @param account [Fission::Data::Models::Account] validated account
      # @param payload [Smash]
      # @return [Smash] account information
      def generate_account_information(account, payload)
        account_data = Smash.new(
          :configs => Smash.new,
          :custom_routes => Smash.new,
          :custom_services => Smash.new
        )
        account.account_configs.each do |a_config|
          account_data[:configs][a_config.name] = a_config.data
        end
        account.routes.each do |a_route|
          account_data[:custom_routes][a_route.name] = Smash.new(
            :path => a_route.route,
            :payload_filters => Smash[
              a_route.route_payload_filters.map{|r_filter|
                [
                  r_filter.name,
                  r_filter.payload_matchers.map{|p_matcher|
                    Smash.new(
                      :payload_key => p_matcher.payload_match_rule.payload_key,
                      :payload_value => p_matcher.value
                    )
                  }
                ]
              }
            ],
            :configs => a_route.route_configs.map{|r_config|
              Smash.new(
                :name => r_config.name,
                :config_packs => r_config.account_configs.map(&:name),
                :payload_matchers => r_config.payload_matchers.map{|p_matcher|
                  Smash.new(
                    :payload_key => p_matcher.payload_match_rule.payload_key,
                    :payload_value => p_matcher.value
                  )
                }
              )
            }
          )
        end
        account.custom_services_dataset.where(:enabled => true).each do |c_service|
          account_data[:custom_services][c_service.name] = c_service.endpoint
        end
        account_info = Smash.new(
          :id => account.id,
          :name => account.name
        )
        account_config = Fission::Utils::Cipher.encrypt(
          MultiJson.dump(:router => account_data),
          :iv => payload[:message_id],
          :key => app_config.fetch(:grouping, self.class::DEFAULT_SECRET)
        )
        account_info[:config] = account_config
        account_info
      end

    end
  end
end
