##
# This code was generated by
# \ / _    _  _|   _  _
#  | (_)\/(_)(_|\/| |(/_  v1.0.0
#       /       /
#
# frozen_string_literal: true

module Twilio
  module REST
    class Api < Domain
      class V2010 < Version
        class AccountContext < InstanceContext
          class NewKeyList < ListResource
            ##
            # Initialize the NewKeyList
            # @param [Version] version Version that contains the resource
            # @param [String] account_sid A 34 character string that uniquely identifies this
            #   resource.
            # @return [NewKeyList] NewKeyList
            def initialize(version, account_sid: nil)
              super(version)

              # Path Solution
              @solution = {account_sid: account_sid}
              @uri = "/Accounts/#{@solution[:account_sid]}/Keys.json"
            end

            ##
            # Create the NewKeyInstance
            # @param [String] friendly_name A descriptive string that you create to describe
            #   the resource. It can be up to 64 characters long.
            # @return [NewKeyInstance] Created NewKeyInstance
            def create(friendly_name: :unset)
              data = Twilio::Values.of({'FriendlyName' => friendly_name, })

              payload = @version.create('POST', @uri, data: data)

              NewKeyInstance.new(@version, payload, account_sid: @solution[:account_sid], )
            end

            ##
            # Provide a user friendly representation
            def to_s
              '#<Twilio.Api.V2010.NewKeyList>'
            end
          end

          class NewKeyPage < Page
            ##
            # Initialize the NewKeyPage
            # @param [Version] version Version that contains the resource
            # @param [Response] response Response from the API
            # @param [Hash] solution Path solution for the resource
            # @return [NewKeyPage] NewKeyPage
            def initialize(version, response, solution)
              super(version, response)

              # Path Solution
              @solution = solution
            end

            ##
            # Build an instance of NewKeyInstance
            # @param [Hash] payload Payload response from the API
            # @return [NewKeyInstance] NewKeyInstance
            def get_instance(payload)
              NewKeyInstance.new(@version, payload, account_sid: @solution[:account_sid], )
            end

            ##
            # Provide a user friendly representation
            def to_s
              '<Twilio.Api.V2010.NewKeyPage>'
            end
          end

          class NewKeyInstance < InstanceResource
            ##
            # Initialize the NewKeyInstance
            # @param [Version] version Version that contains the resource
            # @param [Hash] payload payload that contains response from Twilio
            # @param [String] account_sid A 34 character string that uniquely identifies this
            #   resource.
            # @return [NewKeyInstance] NewKeyInstance
            def initialize(version, payload, account_sid: nil)
              super(version)

              # Marshaled Properties
              @properties = {
                  'sid' => payload['sid'],
                  'friendly_name' => payload['friendly_name'],
                  'date_created' => Twilio.deserialize_rfc2822(payload['date_created']),
                  'date_updated' => Twilio.deserialize_rfc2822(payload['date_updated']),
                  'secret' => payload['secret'],
              }
            end

            ##
            # @return [String] The unique string that identifies the resource
            def sid
              @properties['sid']
            end

            ##
            # @return [String] The string that you assigned to describe the resource
            def friendly_name
              @properties['friendly_name']
            end

            ##
            # @return [Time] The RFC 2822 date and time in GMT that the resource was created
            def date_created
              @properties['date_created']
            end

            ##
            # @return [Time] The RFC 2822 date and time in GMT that the resource was last updated
            def date_updated
              @properties['date_updated']
            end

            ##
            # @return [String] The secret your application uses to sign Access Tokens and to authenticate to the REST API.
            def secret
              @properties['secret']
            end

            ##
            # Provide a user friendly representation
            def to_s
              "<Twilio.Api.V2010.NewKeyInstance>"
            end

            ##
            # Provide a detailed, user friendly representation
            def inspect
              "<Twilio.Api.V2010.NewKeyInstance>"
            end
          end
        end
      end
    end
  end
end