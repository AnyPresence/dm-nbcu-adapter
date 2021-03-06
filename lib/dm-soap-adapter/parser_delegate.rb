
module DataMapper
  module Adapters
    module Soap
      module ParserDelegate
        
        def handle_response(response,model)
          body = response.body
          elements = []
          return elements unless body
          entity = entity_name(model)
          options = @mappings.fetch(entity)
          selector = options['read_response_selector']
          @log.debug("Selector is #{selector}")
          extra_selector_hash = options['extra_selector_hash']
          @log.debug("Extra property selector hash is #{extra_selector_hash}")
          if selector.nil?
            @log.debug("parsing body #{body.inspect}")
            return parse_collection(body, model)
          else
            collection = body
            #TODO: Use XPath or something else
            selector.split('.').each do |exp|
              collection = collection.fetch(exp.to_sym)
            end
            if collection.instance_of? Array
              @log.debug("collection using selector is #{collection.inspect}")
              elements = parse_collection(collection, model)
            else
              
              unless extra_selector_hash.nil? # FTW! Allow the mapping of a property to a value outside the original selector in response
                extra_property = body
                extra_selector = extra_selector_hash.fetch('expression')
                mapped_field = extra_selector_hash.fetch('field').snakecase
                @log.debug("Will use extra selector of #{extra_selector}")
                extra_selector.split('.').each do |exp|
                  extra_property = extra_property.fetch(exp.to_sym)
                end
                @log.debug("---Setting #{mapped_field.to_sym} to size of #{extra_property.size} #{extra_property.inspect}")
                collection[mapped_field.to_sym] = extra_property
              end
              
              elements = [parse_record(collection, model)]
            end
            @log.debug("about to return #{elements}")
            elements
          end
        end
        
        def parse_collection(array, model)
          DataMapper.logger.debug("parse_collection is about to parse\n #{array.inspect}")
          array.collect do |instance|
            parse_record(instance, model)
          end
        end
        
        def parse_record(hash,model)
          field_to_property = make_field_to_property_hash(model)
          DataMapper.logger.debug("parse_record is converting #{hash.inspect} for model #{model}")
          record = record_from_hash(hash, field_to_property)
          DataMapper.logger.debug("Record made from hash is #{record} using #{field_to_property}")
          record
        end

        def record_from_hash(hash, field_to_property)
          record = {}
          hash.each do |field, value|
            DataMapper.logger.debug("#{field} = #{value}")
            name = field.to_s.downcase
            property = field_to_property[name]

            if property.nil?
              property = field_to_property[name.to_sym]
            end
            
            if property.instance_of? DataMapper::Property::Object
              record[property.field] = value
            else
              next unless property
              record[property.field] = property.typecast(value)
            end
          end
          DataMapper.logger.debug("record is #{record}")
          record
        end

        def make_field_to_property_hash(model)
          Hash[ model.properties(model.default_repository_name).map { |p| [ p.field.downcase, p ] } ]
        end
        
        def resource_name(model)
          model.respond_to?(:storage_name) ? model.storage_name(repository_name) : model
        end

      end
    end
  end
end