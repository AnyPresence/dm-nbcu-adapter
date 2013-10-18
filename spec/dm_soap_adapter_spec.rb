require 'spec_helper'

describe DataMapper::Adapters::Soap::Adapter do
  include Savon::SpecHelper
  
  before(:all) do
    @adapter = DataMapper.setup(:default, 
      { adapter: :soap,
        mappings: "{\"plan\":{\"read_xml_ns\":\"ins7\",\"read_params\":{\"id\":\"PlanId\"},\"read_response_selector\":\"plan.plan_header\"},\"inventory\":{\"read_xml_ns\":\"ins4\",\"read_params\":{\"id\":\"Sales_Unit_Id\"},\"read_response_selector\":\"inventory_output.selling_name\"},\"ratecard\":{\"read_xml_ns\":\"ins5\",\"read_params\":{\"id\":\"RC_Id\",\"channel\":\"RC_Channel\"},\"read_response_selector\":\"ratecard.header_info\"},\"overlap\":{\"operation\":\"overlap_su\",\"read_xml_ns\":\"ins3\",\"read_params\":{\"id\":\"Sales_Unit_Id\"},\"read_response_selector\":\"overlap_su_response\"}}"
        #logging_level: 'debug'
      }
    )
    
  end
  
  describe '#read' do
           
      it 'should query Ratecard by ID and other required parameters' do
        ratecards = V1::Ratecard.all(id: 14855, extra_parameters: {'RC_Channel' => 'Oxygen', 'RC_StartQtr' => '3Q13',  'RC_EndQtr' => '3Q14', 'RC_Demo' => 'F18-49'})
        ratecards.size.should == 1
        ratecard = ratecards.first
        ratecard.id.should == 14855
        ratecard.name.should == '13/14 Broadcast Upfront RC as of 2/4/13'
        ratecard.channel.should == 'Oxygen'
      end
      
      it 'should query Plan by ID and other required parameters' do
        plans = V1::Plan.all(id: 100192, extra_parameters: {'SpotInfo' => 'NO'})
        plans.size.should == 1
        plan = plans.first
        plan.id.should == 100192
        plan.name.should == "eugen Hershey's 13/14 Upfront 20.09.2013"
        plan.channel.should == 'Oxygen'
      end
      
      it 'should query Inventory by ID and other required parameters' do
        inventories = V2::Inventory.all(id: 51583, extra_parameters: {
          'Start_Date' => '30-sep-2013',
          'End_Date' => '28-sep-2014',
          'Unit_Duration' => 30,
          'Channel_Name' => "USA",
          'Comm_Type_Name' => "National",
          'Inventory_Type_Code' => "3114000(Pri)",
          'Booking_Mthd_Code' => '1542001(Week)'
          })
        inventories.size.should == 1
        inventory = inventories.first
        inventory.id.should == 51583
        inventory.weeks.size.should == 2
        week = inventory.weeks.first
        week[:week_date].should == '20-Jan-2014'
        week[:capacity].should == "25"
        week[:avails].should == "23"
        week[:sn_sold].should == "2"
        week[:sn_sold_pct].should == "8"
        week[:realistic_sold].should == "2"
        week[:overlap_sold].should == "0"
        week[:sn_pressure].should == "35"
        week[:total_pressure].should == "35"
        
        week = inventory.weeks.last
        week[:week_date].should == '27-Jan-2014'
        week[:capacity].should == "25"
        week[:avails].should == "23"
        week[:sn_sold].should == "2"
        week[:sn_sold_pct].should == "8"
        week[:realistic_sold].should == "2"
        week[:overlap_sold].should == "0"
        week[:sn_pressure].should == "38"
        week[:total_pressure].should == "38"        
      end
      
      it 'should query Overlap by ID and other parameters' do
        overlaps = V3::Overlap.all(id: 46258, extra_parameters: {
          'Start_Date' => '22-aug-2013',
          'NoOfWeeks' => 2,
          'Channel_Name' => 'Oxygen',
          'Comm_Type_Name' => 'National',
          'Day_Type_Id' => 1307001,
          'Inventory_Type_Code' => '3114000(Pri)',
          'Affiliate_Status_Code' => 1853000
        })
        overlaps.size.should == 1
        overlap = overlaps.first
        overlap.id.should == 46258
        overlap.weeks.size.should == 3
        week1 = overlap.weeks[0]
        week1[:week_date].should == '19-Aug-2013'
        week1[:s_unit_id][0].should == '46258'
        week1[:s_unit_id][1].should == '50013'
        week1[:s_unit_id][2].should == '46223'
        week1[:s_unit_id][3].should == '45587'
        week1[:s_unit_id][4].should == '46874'
        week2 = overlap.weeks[1]
        week2[:week_date].should == "26-Aug-2013"
        week2[:s_unit_id][0].should == '46258'
        week2[:s_unit_id][1].should == '46223'
        week2[:s_unit_id][2].should == '45587'
        week2[:s_unit_id][3].should == '46874'
        week2[:s_unit_id][4].should == '50013'
        week2[:s_unit_id][5].should == '46691'
        week3 = overlap.weeks[2]
        week3[:week_date].should == "02-Sep-2013"
        week3[:s_unit_id][0].should == '46258'
        week3[:s_unit_id][1].should == '50013'
        week3[:s_unit_id][2].should == '46874'
        week3[:s_unit_id][3].should == '46691'
        week3[:s_unit_id][4].should == '45587'
        week3[:s_unit_id][5].should == '46223'   
      end
  end
  
end