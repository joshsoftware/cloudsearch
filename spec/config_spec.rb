$:.unshift(File.dirname(__FILE__))
require 'spec_helper'

module Cloudsearch

   describe Config do

     before(:each) do
     end

     it 'should able to load configuration' do
       Config.load('spec/config.yaml')

       config_params = [:admin_endpoint, :version, :service, 
         :region, :endpoint, :access_key_id, :secret_access_key,
         :search_endpoint, :doc_endpoint]

       config_params.each do |m|
         Config.send(m).should_not nil
       end

       Config.search_endpoint.should match /^search-/
       Config.doc_endpoint.should match /^doc-/


     end


   end

end
