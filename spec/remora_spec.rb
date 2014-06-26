require 'spec_helper'

describe Remora do
	before do
		email = ENV['email']||"YOUREMAILHERE"
		password = ENV['password']||"YOURPASSWORDHERE"
		@shark = Remora::Remora.new(email, password)
	end
	# it 'shows my name' do
	# 	expect(@shark.my_name_is).to eq("Hi E R")
	# end
	# it 'checks how many reports left' do
	# 	rl = @shark.reports_left
	# 	expect(rl.split("/")[-1]).to eq("200")
	# end
	it 'loads reports for an SF property' do
		report = @shark.search_in_sf("155 14 St")
		expect(report).to eq({
			:address  => "155 14 St, San Francisco, CA 94103",
			:neighborhood => "Inner Mission  (09C)",
			:building => {
				:sq_ft => "4,900",
				:year_built => "1975"
			},
			:land => {
				:depth => "7,300",
				:lot_sq_ft => "3,650",
				:prop_class => "Flat & Store (F2)",
				:zoning => "Light Industrial (M1)"
			},
			:last_sale => {
				:date => "8/16/2002",
				:price => "$368,000"
			},
			:owner => {
				:address => "251 King Dr",
				:line2 => "Walnut Creek, CA 94595",
				:name => "Flores Family Revoc Lvg Tr"
			}
		})
	end
end

