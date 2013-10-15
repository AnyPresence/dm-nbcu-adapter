module V1
  class Plan
  
  include ::DataMapper::Resource
  
  property :id, Serial, field: 'PLAN_ID'
  property :name, String, field: 'PLAN_NAME'
  property :channel, String, field: 'CHANNEL'
  property :revision_no, Integer, field: 'REVISION_NO'
  property :hold_archived_revision_no, Integer, field: 'HOLD_ARCHIVED_REVISION_NO'
  property :order_archived_revision_no, String, field: 'ORDER_ARCHIVED_REV_NO'
  property :rating_stream, String, field: 'RATING_STREAM'
  property :gauranteed_code, String, field: 'GUARENTEED_CODE'
  property :complaint_code, String, field: 'COMPLIANT_CODE'
  property :hh_post_buy, String, field: 'HH_POST_BUY'
  property :demo_post_buy, String, field: 'DEMO_POST_BUY'
  property :sales_team_name, String, field: 'SALES_TEAM_NAME'
  property :projection_by_code, String, field: 'PROJECTION_BY_CODE'
  property :plan_class, String, field: 'PLAN_CLASS'
  property :marketplace, String, field: 'MARKETPLACE'
  property :status, String, field: 'STATUS'
  property :approval_status, String, field: 'APPROVAL_STATUS'
  property :start_date, Date, field: 'START_DATE'
  property :end_date, Date, field: 'END_DATE'
  property :start_quarter, String, field: 'START_QTR'
  property :end_quarter, String, field: 'END_QTR'
  property :primary_demo, String, field: 'PRIMARY_DEMO'
  property :advertiser, String, field: 'ADVERTISER'
  property :buying_agency, String, field: 'BUYING_AGENCY'
  property :account_exec, String, field: 'ACCOUNT_EXEC'
  property :equalized, String, field: 'EQUALIZED'
  
  end
end