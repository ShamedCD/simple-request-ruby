require 'easy_broker'

RSpec.describe EasyBroker do
    it 'requests the properties' do
        @easy_broker = EasyBroker.new api_key: 'l7u502p8v46ba3ppgvj5y2aad50lb9'
        
        stub_request(:get, "https://api.stagingeb.com/v1/properties").
            with(headers: { "X-Authorization": 'l7u502p8v46ba3ppgvj5y2aad50lb9' }).
            to_return(status: 200, body: '{"pagination":{"next_page":null},"content":[{"public_id":"EB-C0156","title":"Casa con uso de suelo prueba"}]}')
        
        response = @easy_broker.get_all_properties
        expect(response).to match_array(["Casa con uso de suelo prueba"])
        expect(response).to be_an_instance_of(Array)
        expect(@easy_broker.properties).to match_array(response)
    end

    it 'tries to request without API Key' do
        @easy_broker = EasyBroker.new api_key: nil
        expect { @easy_broker.get_all_properties  }.to raise_error(ArgumentError)
    end

    it 'throws an exception when content is empty' do
        @easy_broker = EasyBroker.new api_key: 'l7u502p8v46ba3ppgvj5y2aad50lb9'
        
        stub_request(:get, "https://api.stagingeb.com/v1/properties").
            with(headers: { "X-Authorization": 'l7u502p8v46ba3ppgvj5y2aad50lb9' }).
            to_return(status: 200, body: '{"pagination":{"next_page":null},"content":[]}')

        expect { @easy_broker.get_all_properties  }.to raise_error(ArgumentError)
    end
end