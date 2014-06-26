require "remora/version"
require 'httparty'
require 'nokogiri'

def flush(x,y="")
	File.open("foo#{y}.html","w").write(x)
	system("open foo.html")
end
module Remora
	class Remora
		include HTTParty
		# http_proxy '127.0.0.1', 8888
		# debug_output $stdout
		# base_uri 'www.propertyshark.com/mason/'
		attr_accessor :cookies
		def initialize(u,p)
			@username = u
			@password = p
			response = ""
			response = self.class.get("https://secure.propertyshark.com/mason/Accounts/logon.html",{:verify => false})
			@cookies = cookie_parse(response.headers['Set-Cookie'])
			response = self.class.post(
				"https://secure.propertyshark.com/mason/Accounts/logon.html",
				{
					body: {
						email:u,
						password:p,
						submit:"Sign in",
						tracking_rfs_anon_users:""
					},
					headers: {'Cookie' => @cookies },
					:verify => false
			}
			)
			@cookies = cookie_parse(response.headers['Set-Cookie'])
			response = self.class.get("http://www.propertyshark.com/mason/",headers: {'Cookie' => @cookies},:verify => false)
			# binding.pry
			@cookies = cookie_parse(response.headers['Set-Cookie'])
		end
		def my_name_is
			resp = self.class.get("http://www.propertyshark.com/mason/",headers: {'Cookie' => @cookies },:verify => false)
			sel  = (".account button")
			doc  = Nokogiri::parse(resp.body)
			doc.css(sel).text()
		end
		def reports_left
			resp = self.class.get("http://www.propertyshark.com/mason/Accounts/My/", headers: {'Cookie' => @cookies },:verify => false)
			doc  = Nokogiri::parse(resp.body)
			doc
				.css(".my-subscriptions")[0]
				.css(".details span")[-3]
				.text().strip
		end
		def search_in_sf(address)
			report = {}
			keys = %i{overview ownership sales_history land building}
			keys.each { |k| report[k] = nil }
			report
			binding.pry
			response = self.class.get("http://www.propertyshark.com/mason/ca/San-Francisco-County/Property-Search", headers: {'Cookie' => @cookies },:verify => false)
			search_form = {
				search_type:"address",
				search_types_selector:"address",
				search_token:"155 14th St",
				location:"San Francisco County, CA"
			}
			@cookies = cookie_parse(response.headers['Set-Cookie'])
			resp = self.class.post("http://www.propertyshark.com/mason/UI/homepage_search.html", headers: {'Cookie' => @cookies },:verify => false)

			doc = Nokogiri::parse(resp.body)
			doc.css(".header-address h2").text().strip()
		end
		def cookie_parse(str)
			str.split(" ").select{ |s| s=~/\=/ }.reject{ |s| s=~/(path|expires|domain)/ }.join(" ")
		end
	end
end
