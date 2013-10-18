
module DataMapper
  module Adapters
    module Soap
      class Adapter < DataMapper::Adapters::AbstractAdapter
        include Errors, ParserDelegate, QueryDelegate
        
        def initialize(name, options)
          super
          @options = options
          @expose_connection = @options.fetch(:enable_mock_setters, false)
          initialize_logger
          @mappings = options.fetch(:mappings)
          
          if @mappings.instance_of? String
            DataMapper.logger.debug("Attempting to load string mappings")
            @mappings = JSON.parse(@mappings)
            DataMapper.logger.debug("Loaded #{@mappings.inspect}")
          end
        end

        def connection=(connection)
          @connection = connection if @expose_connection
        end
        
        def connection
          @connection ||= Connection.new(@options)
        end
    
        def get(keys)
      
          response = connection.call_get(keys)

          rescue SoapError => e
            handle_server_outage(e)
        
        end
        
        # Reads one or many resources from a datastore
        #
        # @example
        #   adapter.read(query)  # => [ { 'name' => 'Dan Kubb' } ]
        #
        # Adapters provide specific implementation of this method
        #
        # @param [Query] query
        #   the query to match resources in the datastore
        #
        # @return [Enumerable<Hash>]
        #   an array of hashes to become resources
        #
        # @api semipublic
        def read(query)
          @log.debug("Read #{query.inspect} and its model is #{query.model.inspect}")
          model = query.model
          query_operation = build_query(query)
          query_method = mapped_operation(model)
          begin
            response = connection.call_query(query_method, query_operation)
            return handle_response(response, model)
          rescue SoapError => e
            handle_server_outage(e)
          end
        end
        
        def handle_server_outage(error)
          if error.server_unavailable?
            raise ServerUnavailable, "The SOAP server is currently unavailable"
          else
            raise error
          end
        end
        
        def initialize_logger
          level = 'error'

          if @options[:logging_level] && %w[ off fatal error warn info debug ].include?(@options[:logging_level].downcase)
            level = @options[:logging_level].downcase
          end
          DataMapper::Logger.new($stdout,level)
          @log = DataMapper.logger
        end
      end
    end
    
    ::DataMapper::Adapters::SoapAdapter = DataMapper::Adapters::Soap::Adapter
    self.send(:const_added,:SoapAdapter)
  end
end