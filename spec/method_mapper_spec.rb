# Copyright:: (c) Autotelik Media Ltd 2011
# Author ::   Tom Statter
# Date ::     Aug 2011
# License::   MIT
#
# Details::   Specs for MethodMapper aspect of Active Record Loader
#             MethodMapper provides the bridge between 'strings' e.g column headings
#             and a classes different types of assignment operators
#
require File.join(File.dirname(__FILE__), 'spec_helper')
    
require 'method_mapper'

describe 'Method Mapper' do

  include_context "ClearAndPopulateProject"

  let(:method_mapper)   { DataShift::MethodMapper.new }

  let (:headers)        { [:value_as_string, :owner, :value_as_boolean, :value_as_double] }

  it "should find a set of methods based on a list of column symbols" do
    bindings = method_mapper.map_inbound_headers( Project, headers )
    expect(bindings.size).to eq 4
  end

  it "should leave nil in set of methods when no such operator" do
     
    headers = [:value_as_string, :owner, :bad_no_such_column, :value_as_boolean, :value_as_double, :more_rubbish_as_nil]

    bindings = method_mapper.map_inbound_headers( Project, headers )
    
    expect(bindings.size).to eq 6

    expect(bindings[2]).to be_a DataShift::NoMethodBinding
    expect(bindings[5]).to be_a DataShift::NoMethodBinding

    expect(bindings[0]).to be_a DataShift::MethodBinding
    
  end
  
  it "should map a list of column names to a set of method details", :fail => true do
   
    headers = %w{ value_as_double value_as_string bad_no_such_column value_as_boolean  }

    bindings = method_mapper.map_inbound_headers( Project, headers )

    expect(bindings.size).to eq 4

    expect(bindings[2]).to be_a DataShift::NoMethodBinding

    expect(bindings[0]).to be_a  DataShift::MethodBinding
    expect(bindings.last).to be_a  DataShift::MethodBinding
  end
  
  it "should populate a method detail instance based on column and database info" do
     
    headers = [:value_as_string, :owner, :value_as_boolean, :value_as_double]

    bindings = method_mapper.map_inbound_headers( Project, headers )
    
    expect(bindings.size).to eq 4

    expect(bindings[0]).to be_a  DataShift::MethodBinding
    
    headers.each_with_index do |c, i|
      expect(bindings[i].inbound_index).to eq i
      expect(bindings[i].inbound_column.index).to eq i
    end
      
  end
  
  it "should map between user name and real class operator and store in method detail instance", :fail => true do
     
    headers = [ "Value as string", 'owner', "value_as boolean", 'Value_As_Double']
    
    operators = %w{ value_as_string owner value_as_boolean value_as_double }

    bindings = method_mapper.map_inbound_headers( Project, headers )

    expect(bindings.size).to eq 4
    
    headers.each_with_index do |c, i|
      expect(bindings[i].valid?).to eq true
      expect(bindings[i].inbound_index).to eq  i
      expect(bindings[i].inbound_name).to eq  c
      expect(bindings[i].operator).to eq operators[i]
    end
    
  end

  
end