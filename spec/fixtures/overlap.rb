module V3
  class Overlap
    include ::DataMapper::Resource
    
    property :id, Serial, field: 'Sales_Unit_Id'
    property :weeks, Object, field: 'week'
  end
end