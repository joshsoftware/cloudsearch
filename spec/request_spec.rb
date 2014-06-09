$:.unshift(File.dirname(__FILE__))
require 'spec_helper'

module Cloudsearch

  describe Request do

    before do
      @config = Config.load('spec/config.yaml', 'test')
    end

    it "should make authorize request" do
      req = Request.new(:get, Config.admin_endpoint) do |r|
        r.params = {:action => 'CreateDomain'}
      end

      p req.add_authorization

    end

  end

end
