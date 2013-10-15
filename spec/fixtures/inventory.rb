module V2
  class Inventory
    include ::DataMapper::Resource
    
    property :id, Serial, field: 'Sales_Unit_Id'
    property :weeks, Object, field: 'week'
  end
end