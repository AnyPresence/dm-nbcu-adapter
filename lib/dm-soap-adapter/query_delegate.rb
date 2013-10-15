module DataMapper
  module Adapters
    module Soap
      module QueryDelegate
        
        def build_query(query)
          query_hash = {}
          entity = entity_name(query.model)
          DataMapper.logger.debug("Looking up #{entity} in mappings.")
          options = @mappings.fetch(entity)
          xml_ns = options.fetch(:read_xml_ns,nil)
          if query.conditions
            options.fetch(:read_params).each do |dm_property_name, wsdl_remote_name|
              if (value = find_condition_value_for_property_name(query.conditions, dm_property_name))
                if xml_ns.nil?
                  query_hash[wsdl_remote_name] = value
                else
                  query_hash["#{xml_ns}:#{wsdl_remote_name}"] = value
                end
              end
            end
          end    
          query.extra_parameters.each do |param, value|
            if xml_ns.nil?
              query_hash[param] = value
            else
              query_hash["#{xml_ns}:#{param}"] = value
            end
          end
          DataMapper.logger.debug("build_query is returning #{query_hash}")     
          query_hash
        end
        
        def build_create(resource)
          raise "Not yet implemented!"
        end
        
        def mapped_operation(model)
          entity = entity_name(model)
          options = @mappings.fetch(entity)
          if options.has_key?(:operation)
            return options.fetch(:operation)
          else
            return entity
          end
        end
        
        private
        
        def entity_name(model)
          DataMapper::Inflector.singularize(model.name.split(/::/).last).downcase
        end
        
        def find_condition_value_for_property_name(conditions, property_name)
          conditions.each do |condition| 
            if condition.instance_of? DataMapper::Query::Conditions::EqualToComparison 
              return condition.loaded_value if condition.subject.name.to_sym == property_name.to_sym
            else
              raise "Not yet implemented!"
            end
          end
          return nil
        end
        
      end
    end
  end
end