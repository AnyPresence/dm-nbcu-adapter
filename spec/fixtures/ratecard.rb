module V1
  class Ratecard
  
    include ::DataMapper::Resource
    
    property :id, Serial, field: 'US_Ratecard_ID'
    property :name, String, field: 'US_Ratecard_Name'
    property :channel, String, field: 'Channel_Name'
    property :start_date, Date, field: 'StartDate'
    property :end_date, Date, field: 'EndDate'
    property :commercial_type, String, field: 'Commercial_Type_Name'
    property :commercial_sub_type, String, field: 'Commercial_Sub_Type_name'
    property :deal_class_name, String, field: 'Deal_Class_Name'
    property :marketplace, String, field: 'Marketplace_Name'
    property :ratingstream, String, field: 'Ratingstream_Name'
  
  end
end