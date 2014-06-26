require 'spec_helper'

describe Remora do
	before do
		email = ENV['email']||"YOUREMAILHERE"
		password = ENV['password']||"YOURPASSWORDHERE"
		@shark = Remora::Remora.new(email, password)
	end
	it 'shows my name' do
		expect(@shark.my_name_is).to eq("Hi E R")
	end
	it 'checks how many reports left' do
		rl = @shark.reports_left
		expect(rl.split("/")[-1]).to eq("200")
	end
	it 'loads reports for an SF property' do

		report = @shark.search_in_sf("155 14 St")
		# expect(report.class).to be(Hash)
		report_sections_keys = %i{overview ownership sales_history land building}
		expect(report).to eq("155 14 St, San Francisco, CA 94103")
		# expect(report).to include(*report_sections_keys)
	end
end

