require 'httparty'
require 'json'

class EasyBroker
    include HTTParty

    attr_reader :properties

    @@endpoint = 'https://api.stagingeb.com/v1/properties'

    def initialize(api_key:)
        @api_key = api_key
        @properties = []
    end

    def get_all_properties
        validate_api_key
        res = HTTParty.get @@endpoint, headers: { 'X-Authorization': @api_key }
        data = JSON.parse(res.body)
        
        merge_property_titles properties_array: data['content']

        if data['pagination']['next_page'].nil?
            @properties
        else
            @@endpoint = data['pagination']['next_page']
            get_all_properties
        end
    end

    private
        def validate_api_key
            raise ArgumentError, "The API Key was not provided" if @api_key.nil?
        end

        def merge_property_titles(properties_array:)
            raise ArgumentError, "The properties array is empty" if properties_array.empty?

            tmp_array = properties_array.map { |prop| prop['title'] }
            @properties.concat(tmp_array) 
        end

end

# easy_broker = EasyBroker.new api_key: 'l7u502p8v46ba3ppgvj5y2aad50lb9'
# properties = easy_broker.get_all_properties

# puts properties
