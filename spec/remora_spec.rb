require 'spec_helper'

describe Remora do
	before do
		email = ENV['email']||"YOUREMAILHERE"
		password = ENV['password']||"YOURPASSWORDHERE"
		@shark = Remora::Remora.new(email, password)
	end
	describe '.my_name_is' do
		it 'shows my name' do
			expect(@shark.my_name_is).to eq("Hi E R")
		end
	end
	describe ".reports_left" do
		it 'checks how many reports left' do
			rl = @shark.reports_left
			expect(rl.split("/")[-1]).to eq("200")
		end
	end
	describe ".search_in_sf" do
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
	describe '.search_by_name_in_sf' do
		context 'a person has one property' do
			it 'the Flores Family Lvg Tr' do
				properties = @shark.search_by_name_in_sf("Flores Family Revoc Lvg Tr")
				expect(properties.length).to eq(1)
				expect(properties[0][:address]).to eq("155 14 St")
				expect(properties[0][:owner]).to  eq("Flores Family Revoc Lvg Tr")
			end
		end
		context 'just a last name' do
			it 'the Steins' do
				properties = @shark.search_by_name_in_sf("Stein")
				expect(properties.length).to eq(128)

				expect(properties[0][:address]).to eq("954 De Haro St")
				expect(properties[0][:owner]).to  eq("Stein Quinton F Herz")

				expect(properties[1][:address]).to eq("925-927 Dolores St")
				expect(properties[1][:owner]).to  eq("Katherine Stein Trust")

				randys_property = properties.find{ |p| p[:owner]=="Stein Randy" }
				expect(randys_property[:address]).to eq("3550 Market St #102")
			end
		end
	end
end

