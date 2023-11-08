##
# This code was generated by
# \ / _    _  _|   _  _
#  | (_)\/(_)(_|\/| |(/_  v1.0.0
#       /       /
#
# frozen_string_literal: true

module Twilio
  module REST
    class Messaging < Domain
      class V1 < Version
        ##
        # PLEASE NOTE that this class contains beta products that are subject to change. Use them with caution.
        class TollfreeVerificationList < ListResource
          ##
          # Initialize the TollfreeVerificationList
          # @param [Version] version Version that contains the resource
          # @return [TollfreeVerificationList] TollfreeVerificationList
          def initialize(version)
            super(version)

            # Path Solution
            @solution = {}
            @uri = "/Tollfree/Verifications"
          end

          ##
          # Lists TollfreeVerificationInstance records from the API as a list.
          # Unlike stream(), this operation is eager and will load `limit` records into
          # memory before returning.
          # @param [String] tollfree_phone_number_sid The SID of the Phone Number associated
          #   with the Tollfree Verification.
          # @param [tollfree_verification.Status] status The compliance status of the
          #   Tollfree Verification record.
          # @param [Integer] limit Upper limit for the number of records to return. stream()
          #    guarantees to never return more than limit.  Default is no limit
          # @param [Integer] page_size Number of records to fetch per request, when
          #    not set will use the default value of 50 records.  If no page_size is defined
          #    but a limit is defined, stream() will attempt to read the limit with the most
          #    efficient page size, i.e. min(limit, 1000)
          # @return [Array] Array of up to limit results
          def list(tollfree_phone_number_sid: :unset, status: :unset, limit: nil, page_size: nil)
            self.stream(
                tollfree_phone_number_sid: tollfree_phone_number_sid,
                status: status,
                limit: limit,
                page_size: page_size
            ).entries
          end

          ##
          # Streams TollfreeVerificationInstance records from the API as an Enumerable.
          # This operation lazily loads records as efficiently as possible until the limit
          # is reached.
          # @param [String] tollfree_phone_number_sid The SID of the Phone Number associated
          #   with the Tollfree Verification.
          # @param [tollfree_verification.Status] status The compliance status of the
          #   Tollfree Verification record.
          # @param [Integer] limit Upper limit for the number of records to return. stream()
          #    guarantees to never return more than limit. Default is no limit.
          # @param [Integer] page_size Number of records to fetch per request, when
          #    not set will use the default value of 50 records. If no page_size is defined
          #    but a limit is defined, stream() will attempt to read the limit with the most
          #    efficient page size, i.e. min(limit, 1000)
          # @return [Enumerable] Enumerable that will yield up to limit results
          def stream(tollfree_phone_number_sid: :unset, status: :unset, limit: nil, page_size: nil)
            limits = @version.read_limits(limit, page_size)

            page = self.page(
                tollfree_phone_number_sid: tollfree_phone_number_sid,
                status: status,
                page_size: limits[:page_size],
            )

            @version.stream(page, limit: limits[:limit], page_limit: limits[:page_limit])
          end

          ##
          # When passed a block, yields TollfreeVerificationInstance records from the API.
          # This operation lazily loads records as efficiently as possible until the limit
          # is reached.
          def each
            limits = @version.read_limits

            page = self.page(page_size: limits[:page_size], )

            @version.stream(page,
                            limit: limits[:limit],
                            page_limit: limits[:page_limit]).each {|x| yield x}
          end

          ##
          # Retrieve a single page of TollfreeVerificationInstance records from the API.
          # Request is executed immediately.
          # @param [String] tollfree_phone_number_sid The SID of the Phone Number associated
          #   with the Tollfree Verification.
          # @param [tollfree_verification.Status] status The compliance status of the
          #   Tollfree Verification record.
          # @param [String] page_token PageToken provided by the API
          # @param [Integer] page_number Page Number, this value is simply for client state
          # @param [Integer] page_size Number of records to return, defaults to 50
          # @return [Page] Page of TollfreeVerificationInstance
          def page(tollfree_phone_number_sid: :unset, status: :unset, page_token: :unset, page_number: :unset, page_size: :unset)
            params = Twilio::Values.of({
                'TollfreePhoneNumberSid' => tollfree_phone_number_sid,
                'Status' => status,
                'PageToken' => page_token,
                'Page' => page_number,
                'PageSize' => page_size,
            })

            response = @version.page('GET', @uri, params: params)

            TollfreeVerificationPage.new(@version, response, @solution)
          end

          ##
          # Retrieve a single page of TollfreeVerificationInstance records from the API.
          # Request is executed immediately.
          # @param [String] target_url API-generated URL for the requested results page
          # @return [Page] Page of TollfreeVerificationInstance
          def get_page(target_url)
            response = @version.domain.request(
                'GET',
                target_url
            )
            TollfreeVerificationPage.new(@version, response, @solution)
          end

          ##
          # Create the TollfreeVerificationInstance
          # @param [String] business_name The name of the business or organization using the
          #   Tollfree number.
          # @param [String] business_website The website of the business or organization
          #   using the Tollfree number.
          # @param [String] notification_email The email address to receive the notification
          #   about the verification result. .
          # @param [Array[String]] use_case_categories The category of the use case for the
          #   Tollfree Number. List as many are applicable..
          # @param [String] use_case_summary Use this to further explain how messaging is
          #   used by the business or organization.
          # @param [String] production_message_sample An example of message content, i.e. a
          #   sample message.
          # @param [Array[String]] opt_in_image_urls Link to an image that shows the opt-in
          #   workflow. Multiple images allowed and must be a publicly hosted URL.
          # @param [tollfree_verification.OptInType] opt_in_type Describe how a user opts-in
          #   to text messages.
          # @param [String] message_volume Estimate monthly volume of messages from the
          #   Tollfree Number.
          # @param [String] tollfree_phone_number_sid The SID of the Phone Number associated
          #   with the Tollfree Verification.
          # @param [String] customer_profile_sid Customer's Profile Bundle BundleSid.
          # @param [String] business_street_address The address of the business or
          #   organization using the Tollfree number.
          # @param [String] business_street_address2 The address of the business or
          #   organization using the Tollfree number.
          # @param [String] business_city The city of the business or organization using the
          #   Tollfree number.
          # @param [String] business_state_province_region The state/province/region of the
          #   business or organization using the Tollfree number.
          # @param [String] business_postal_code The postal code of the business or
          #   organization using the Tollfree number.
          # @param [String] business_country The country of the business or organization
          #   using the Tollfree number.
          # @param [String] additional_information Additional information to be provided for
          #   verification.
          # @param [String] business_contact_first_name The first name of the contact for
          #   the business or organization using the Tollfree number.
          # @param [String] business_contact_last_name The last name of the contact for the
          #   business or organization using the Tollfree number.
          # @param [String] business_contact_email The email address of the contact for the
          #   business or organization using the Tollfree number.
          # @param [String] business_contact_phone The phone number of the contact for the
          #   business or organization using the Tollfree number.
          # @return [TollfreeVerificationInstance] Created TollfreeVerificationInstance
          def create(business_name: nil, business_website: nil, notification_email: nil, use_case_categories: nil, use_case_summary: nil, production_message_sample: nil, opt_in_image_urls: nil, opt_in_type: nil, message_volume: nil, tollfree_phone_number_sid: nil, customer_profile_sid: :unset, business_street_address: :unset, business_street_address2: :unset, business_city: :unset, business_state_province_region: :unset, business_postal_code: :unset, business_country: :unset, additional_information: :unset, business_contact_first_name: :unset, business_contact_last_name: :unset, business_contact_email: :unset, business_contact_phone: :unset)
            data = Twilio::Values.of({
                'BusinessName' => business_name,
                'BusinessWebsite' => business_website,
                'NotificationEmail' => notification_email,
                'UseCaseCategories' => Twilio.serialize_list(use_case_categories) { |e| e },
                'UseCaseSummary' => use_case_summary,
                'ProductionMessageSample' => production_message_sample,
                'OptInImageUrls' => Twilio.serialize_list(opt_in_image_urls) { |e| e },
                'OptInType' => opt_in_type,
                'MessageVolume' => message_volume,
                'TollfreePhoneNumberSid' => tollfree_phone_number_sid,
                'CustomerProfileSid' => customer_profile_sid,
                'BusinessStreetAddress' => business_street_address,
                'BusinessStreetAddress2' => business_street_address2,
                'BusinessCity' => business_city,
                'BusinessStateProvinceRegion' => business_state_province_region,
                'BusinessPostalCode' => business_postal_code,
                'BusinessCountry' => business_country,
                'AdditionalInformation' => additional_information,
                'BusinessContactFirstName' => business_contact_first_name,
                'BusinessContactLastName' => business_contact_last_name,
                'BusinessContactEmail' => business_contact_email,
                'BusinessContactPhone' => business_contact_phone,
            })

            payload = @version.create('POST', @uri, data: data)

            TollfreeVerificationInstance.new(@version, payload, )
          end

          ##
          # Provide a user friendly representation
          def to_s
            '#<Twilio.Messaging.V1.TollfreeVerificationList>'
          end
        end

        ##
        # PLEASE NOTE that this class contains beta products that are subject to change. Use them with caution.
        class TollfreeVerificationPage < Page
          ##
          # Initialize the TollfreeVerificationPage
          # @param [Version] version Version that contains the resource
          # @param [Response] response Response from the API
          # @param [Hash] solution Path solution for the resource
          # @return [TollfreeVerificationPage] TollfreeVerificationPage
          def initialize(version, response, solution)
            super(version, response)

            # Path Solution
            @solution = solution
          end

          ##
          # Build an instance of TollfreeVerificationInstance
          # @param [Hash] payload Payload response from the API
          # @return [TollfreeVerificationInstance] TollfreeVerificationInstance
          def get_instance(payload)
            TollfreeVerificationInstance.new(@version, payload, )
          end

          ##
          # Provide a user friendly representation
          def to_s
            '<Twilio.Messaging.V1.TollfreeVerificationPage>'
          end
        end

        ##
        # PLEASE NOTE that this class contains beta products that are subject to change. Use them with caution.
        class TollfreeVerificationContext < InstanceContext
          ##
          # Initialize the TollfreeVerificationContext
          # @param [Version] version Version that contains the resource
          # @param [String] sid The unique string to identify Tollfree Verification.
          # @return [TollfreeVerificationContext] TollfreeVerificationContext
          def initialize(version, sid)
            super(version)

            # Path Solution
            @solution = {sid: sid, }
            @uri = "/Tollfree/Verifications/#{@solution[:sid]}"
          end

          ##
          # Fetch the TollfreeVerificationInstance
          # @return [TollfreeVerificationInstance] Fetched TollfreeVerificationInstance
          def fetch
            payload = @version.fetch('GET', @uri)

            TollfreeVerificationInstance.new(@version, payload, sid: @solution[:sid], )
          end

          ##
          # Provide a user friendly representation
          def to_s
            context = @solution.map {|k, v| "#{k}: #{v}"}.join(',')
            "#<Twilio.Messaging.V1.TollfreeVerificationContext #{context}>"
          end

          ##
          # Provide a detailed, user friendly representation
          def inspect
            context = @solution.map {|k, v| "#{k}: #{v}"}.join(',')
            "#<Twilio.Messaging.V1.TollfreeVerificationContext #{context}>"
          end
        end

        ##
        # PLEASE NOTE that this class contains beta products that are subject to change. Use them with caution.
        class TollfreeVerificationInstance < InstanceResource
          ##
          # Initialize the TollfreeVerificationInstance
          # @param [Version] version Version that contains the resource
          # @param [Hash] payload payload that contains response from Twilio
          # @param [String] sid The unique string to identify Tollfree Verification.
          # @return [TollfreeVerificationInstance] TollfreeVerificationInstance
          def initialize(version, payload, sid: nil)
            super(version)

            # Marshaled Properties
            @properties = {
                'sid' => payload['sid'],
                'account_sid' => payload['account_sid'],
                'customer_profile_sid' => payload['customer_profile_sid'],
                'trust_product_sid' => payload['trust_product_sid'],
                'date_created' => Twilio.deserialize_iso8601_datetime(payload['date_created']),
                'date_updated' => Twilio.deserialize_iso8601_datetime(payload['date_updated']),
                'regulated_item_sid' => payload['regulated_item_sid'],
                'business_name' => payload['business_name'],
                'business_street_address' => payload['business_street_address'],
                'business_street_address2' => payload['business_street_address2'],
                'business_city' => payload['business_city'],
                'business_state_province_region' => payload['business_state_province_region'],
                'business_postal_code' => payload['business_postal_code'],
                'business_country' => payload['business_country'],
                'business_website' => payload['business_website'],
                'business_contact_first_name' => payload['business_contact_first_name'],
                'business_contact_last_name' => payload['business_contact_last_name'],
                'business_contact_email' => payload['business_contact_email'],
                'business_contact_phone' => payload['business_contact_phone'],
                'notification_email' => payload['notification_email'],
                'use_case_categories' => payload['use_case_categories'],
                'use_case_summary' => payload['use_case_summary'],
                'production_message_sample' => payload['production_message_sample'],
                'opt_in_image_urls' => payload['opt_in_image_urls'],
                'opt_in_type' => payload['opt_in_type'],
                'message_volume' => payload['message_volume'],
                'additional_information' => payload['additional_information'],
                'tollfree_phone_number_sid' => payload['tollfree_phone_number_sid'],
                'status' => payload['status'],
                'url' => payload['url'],
                'resource_links' => payload['resource_links'],
            }

            # Context
            @instance_context = nil
            @params = {'sid' => sid || @properties['sid'], }
          end

          ##
          # Generate an instance context for the instance, the context is capable of
          # performing various actions.  All instance actions are proxied to the context
          # @return [TollfreeVerificationContext] TollfreeVerificationContext for this TollfreeVerificationInstance
          def context
            unless @instance_context
              @instance_context = TollfreeVerificationContext.new(@version, @params['sid'], )
            end
            @instance_context
          end

          ##
          # @return [String] Tollfree Verification Sid
          def sid
            @properties['sid']
          end

          ##
          # @return [String] The SID of the Account that created the resource
          def account_sid
            @properties['account_sid']
          end

          ##
          # @return [String] Customer's Profile Bundle BundleSid
          def customer_profile_sid
            @properties['customer_profile_sid']
          end

          ##
          # @return [String] Tollfree TrustProduct Bundle BundleSid
          def trust_product_sid
            @properties['trust_product_sid']
          end

          ##
          # @return [Time] The ISO 8601 date and time in GMT when the resource was created
          def date_created
            @properties['date_created']
          end

          ##
          # @return [Time] The ISO 8601 date and time in GMT when the resource was last updated
          def date_updated
            @properties['date_updated']
          end

          ##
          # @return [String] The SID of the Regulated Item
          def regulated_item_sid
            @properties['regulated_item_sid']
          end

          ##
          # @return [String] The name of the business or organization using the Tollfree number
          def business_name
            @properties['business_name']
          end

          ##
          # @return [String] The address of the business or organization using the Tollfree number
          def business_street_address
            @properties['business_street_address']
          end

          ##
          # @return [String] The address of the business or organization using the Tollfree number
          def business_street_address2
            @properties['business_street_address2']
          end

          ##
          # @return [String] The city of the business or organization using the Tollfree number
          def business_city
            @properties['business_city']
          end

          ##
          # @return [String] The state/province/region of the business or organization using the Tollfree number
          def business_state_province_region
            @properties['business_state_province_region']
          end

          ##
          # @return [String] The postal code of the business or organization using the Tollfree number
          def business_postal_code
            @properties['business_postal_code']
          end

          ##
          # @return [String] The country of the business or organization using the Tollfree number
          def business_country
            @properties['business_country']
          end

          ##
          # @return [String] The website of the business or organization using the Tollfree number
          def business_website
            @properties['business_website']
          end

          ##
          # @return [String] The first name of the contact for the business or organization using the Tollfree number
          def business_contact_first_name
            @properties['business_contact_first_name']
          end

          ##
          # @return [String] The last name of the contact for the business or organization using the Tollfree number
          def business_contact_last_name
            @properties['business_contact_last_name']
          end

          ##
          # @return [String] The email address of the contact for the business or organization using the Tollfree number
          def business_contact_email
            @properties['business_contact_email']
          end

          ##
          # @return [String] The phone number of the contact for the business or organization using the Tollfree number
          def business_contact_phone
            @properties['business_contact_phone']
          end

          ##
          # @return [String] The email address to receive the notification about the verification result.
          def notification_email
            @properties['notification_email']
          end

          ##
          # @return [Array[String]] The category of the use case for the Tollfree Number. List as many are applicable.
          def use_case_categories
            @properties['use_case_categories']
          end

          ##
          # @return [String] Further explaination on how messaging is used by the business or organization
          def use_case_summary
            @properties['use_case_summary']
          end

          ##
          # @return [String] An example of message content, i.e. a sample message
          def production_message_sample
            @properties['production_message_sample']
          end

          ##
          # @return [Array[String]] Link to an image that shows the opt-in workflow. Multiple images allowed and must be a publicly hosted URL
          def opt_in_image_urls
            @properties['opt_in_image_urls']
          end

          ##
          # @return [tollfree_verification.OptInType] Describe how a user opts-in to text messages
          def opt_in_type
            @properties['opt_in_type']
          end

          ##
          # @return [String] Estimate monthly volume of messages from the Tollfree Number
          def message_volume
            @properties['message_volume']
          end

          ##
          # @return [String] Additional information to be provided for verification
          def additional_information
            @properties['additional_information']
          end

          ##
          # @return [String] The SID of the Phone Number associated with the Tollfree Verification
          def tollfree_phone_number_sid
            @properties['tollfree_phone_number_sid']
          end

          ##
          # @return [tollfree_verification.Status] The compliance status of the Tollfree Verification record.
          def status
            @properties['status']
          end

          ##
          # @return [String] The absolute URL of the Tollfree Verification
          def url
            @properties['url']
          end

          ##
          # @return [Hash] The URLs of the documents associated with the Tollfree Verification resource
          def resource_links
            @properties['resource_links']
          end

          ##
          # Fetch the TollfreeVerificationInstance
          # @return [TollfreeVerificationInstance] Fetched TollfreeVerificationInstance
          def fetch
            context.fetch
          end

          ##
          # Provide a user friendly representation
          def to_s
            values = @params.map{|k, v| "#{k}: #{v}"}.join(" ")
            "<Twilio.Messaging.V1.TollfreeVerificationInstance #{values}>"
          end

          ##
          # Provide a detailed, user friendly representation
          def inspect
            values = @properties.map{|k, v| "#{k}: #{v}"}.join(" ")
            "<Twilio.Messaging.V1.TollfreeVerificationInstance #{values}>"
          end
        end
      end
    end
  end
end