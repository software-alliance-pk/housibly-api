##
# This code was generated by
# \ / _    _  _|   _  _
#  | (_)\/(_)(_|\/| |(/_  v1.0.0
#       /       /
#
# frozen_string_literal: true

module Twilio
  module REST
    class Routes < Domain
      ##
      # Initialize the Routes Domain
      def initialize(twilio)
        super

        @base_url = 'https://routes.twilio.com'
        @host = 'routes.twilio.com'
        @port = 443

        # Versions
        @v2 = nil
      end

      ##
      # Version v2 of routes
      def v2
        @v2 ||= V2.new self
      end

      ##
      # @param [String] phone_number The phone number in E.164 format
      # @return [Twilio::REST::Routes::V2::PhoneNumberInstance] if phone_number was passed.
      # @return [Twilio::REST::Routes::V2::PhoneNumberList]
      def phone_numbers(phone_number=:unset)
        self.v2.phone_numbers(phone_number)
      end

      ##
      # @param [String] sip_domain The sip_domain
      # @return [Twilio::REST::Routes::V2::SipDomainInstance] if sip_domain was passed.
      # @return [Twilio::REST::Routes::V2::SipDomainList]
      def sip_domains(sip_domain=:unset)
        self.v2.sip_domains(sip_domain)
      end

      ##
      # @param [String] sip_trunk_domain The absolute URL of the SIP Trunk
      # @return [Twilio::REST::Routes::V2::TrunkInstance] if sip_trunk_domain was passed.
      # @return [Twilio::REST::Routes::V2::TrunkList]
      def trunks(sip_trunk_domain=:unset)
        self.v2.trunks(sip_trunk_domain)
      end

      ##
      # Provide a user friendly representation
      def to_s
        '#<Twilio::REST::Routes>'
      end
    end
  end
end