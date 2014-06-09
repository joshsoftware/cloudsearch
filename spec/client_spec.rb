$:.unshift(File.dirname(__FILE__))
require 'spec_helper'
require 'nokogiri'

module Cloudsearch

  describe Client do

    before(:all) do
      @config = Config.load('spec/config.yaml', 'test')
      Locals.load
      @client = Client.new
    end
    
    describe "Define Index GET" do

      it "should create a new index with no datatype" do
        response = @client.define_index_field({
          index_field:  {
            index_name: "year"
          }
        })
        response = Nokogiri::XML(response) 
        response.search('IndexFieldName')[0].content.should eq('year')
        response.search('IndexFieldType')[0].content.should eq('text')
      end

      it "should create a new index with integer datatype" do
        response = @client.define_index_field({
          index_field:  {
            index_name:   "year", 
            index_type:   "uint", 
            uint_options: { default: 0 }
          }
        })
        
        response = Nokogiri::XML(response) 
        response.search('IndexFieldName')[0].content.should eq('year')
        response.search('IndexFieldType')[0].content.should eq('uint')
        response.search('DefaultValue')[0].content.should eq('0')
      end

      it "should create a new index with text datatype" do
        response = @client.define_index_field({
          index_field:  {
            index_name:   "year", 
            index_type:   "text", 
            text_options: { result_enabled: true }
          }
        })

        response = Nokogiri::XML(response) 
        response.search('IndexFieldName')[0].content.should eq('year')
        response.search('IndexFieldType')[0].content.should eq('text')
        response.search('ResultEnabled')[0].content.should eq('true')
      end

      it "should create a new index with literal datatype" do
        response = @client.define_index_field({
          index_field:  {
            index_name:   "year", 
            index_type:   "literal", 
            literal_options: { facet_enabled: true }
          }
        })

        response = Nokogiri::XML(response) 
        response.search('IndexFieldName')[0].content.should eq('year')
        response.search('IndexFieldType')[0].content.should eq('literal')
        response.search('FacetEnabled')[0].content.should eq('true')
      end

      it "should throw error if type & the options sent are different(e.g type => 'text' & option => 'literaloptions')" do
        response = @client.define_index_field({
          index_field:  {
            index_name:   "year", 
            index_type:   "text", 
            literal_options: { facet_enabled: true }
          }
        })

        response = Nokogiri::XML(response) 
        response.search('Error//Code')[0].content.should eq('InvalidType')
      end

      it "should throw error if index_name if empty index_field given" do
        begin
          response = @client.define_index_field({ index_field: {}})
        rescue Exception => e
          e.message.should eq('index_name is required')
        end
      end

    end

    describe "define Search GET" do
      it "should search based on the requested parameters" do
        response = @client.search({
          q: 'iphone',
          "return-fields" => 'name'
        })
        p response
      end
    end

  end

end
