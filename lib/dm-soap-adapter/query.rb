module DataMapper
  
  # This tweaked query class allows the user to supply a specialized query that has arbitrary parameters
  # that have nothing to do with the model queried. This is deliberaty done to support a SOAP service
  # containing all kinds of XML input payloads that are required but have no mappings in its entities.
  #
  class Query
    
    attr_accessor :extra_parameters
    
    # Validate the options and ignores a key of :extra_parameters if present
    #
    # @param [#each] options
    #   the options to validate
    #
    # @raise [ArgumentError]
    #   if any pairs in +options+ are invalid options
    #
    # @api private
    def assert_valid_options(options)
      options = options.to_hash
      
      # Replace options with actual query options sans the extra parameters we had to stuff
      if options.has_key?(:extra_parameters)
        DataMapper.logger.debug("About to delete extra parameters to pass validation")
        @replacement = {}
        options.each do |key, value|
          if key == :extra_parameters
            @extra_parameters = value
          else
            @replacement[key] = value
          end
        end
        DataMapper.logger.debug("Replacing frozen options with #{@replacement}")
        options = @replacement.freeze
      end
      
      options.each do |attribute, value|
        case attribute
          when :fields                         then assert_valid_fields(value, options[:unique])
          when :links                          then assert_valid_links(value)
          when :conditions                     then assert_valid_conditions(value)
          when :offset                         then assert_valid_offset(value, options[:limit])
          when :limit                          then assert_valid_limit(value)
          when :order                          then assert_valid_order(value, options[:fields])
          when :unique, :add_reversed, :reload then assert_valid_boolean("options[:#{attribute}]", value)
          else
            assert_valid_conditions(attribute => value)
        end
      end
    end
    
    # Append conditions to this Query and ignores a key of :extra_parameters if present
    #
    # @param [Property, Symbol, String, Operator, Associations::Relationship, Path] subject
    #   the subject to match
    # @param [Object] bind_value
    #   the value to match on
    # @param [Symbol] operator
    #   the operator to match with
    #
    # @return [Query::Conditions::AbstractOperation]
    #   the Query conditions
    #
    # @api private
    def append_condition(subject, bind_value, model = self.model, operator = :eql)
      case subject
        when Property, Associations::Relationship then append_property_condition(subject, bind_value, operator)
        when Symbol                               then append_symbol_condition(subject, bind_value, model, operator)
        when String                               then append_string_condition(subject, bind_value, model, operator)
        when Operator                             then append_operator_conditions(subject, bind_value, model)
        when Path                                 then append_path(subject, bind_value, model, operator)
        else
          is_extra_parameters = subject.nil? && bind_value.instance_of?(Hash) && bind_value == @extra_parameters
          raise ArgumentError, "#{subject} is an invalid instance: #{subject.class}" unless is_extra_parameters
      end
    end
  end
end