require "remora/version"
require 'mechanize'
require 'nokogiri'

def flush(x,y="")
	File.open("foo#{y}.html","w").write(x)
	system("open foo.html")
end
module Remora
	class Remora
		attr_accessor :cookies
		def initialize(u,p)
			@agent = Mechanize.new
			@username = u
			@password = p
			response = ""
			@agent.get("https://secure.propertyshark.com/mason/Accounts/logon.html")
			r1 = @agent.post(
				"https://secure.propertyshark.com/mason/Accounts/logon.html",
				{
						email:u,
						password:p,
						submit:"Sign in",
						tracking_rfs_anon_users:""
			})
			response = @agent.get("http://www.propertyshark.com/mason/",headers: {'Cookie' => @cookies})
		end
		def my_name_is
			resp = @agent.get("http://www.propertyshark.com/mason/")
			sel  = (".account button")
			doc  = Nokogiri::parse(resp.body)
			doc.css(sel).text()
		end
		def reports_left
			resp = @agent.get("http://www.propertyshark.com/mason/Accounts/My/")
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
			response = @agent.get("http://www.propertyshark.com/mason/ca/San-Francisco-County/Property-Search")
			search_form = {
				search_type:"address",
				search_types_selector:"address",
				search_token:"155 14th St",
				location:"San Francisco County, CA"
			}
			resp = @agent.post("http://www.propertyshark.com/mason/UI/homepage_search.html",search_form)

			doc = Nokogiri::parse(resp.body)
			doc.css(".header-address h2").text().strip()[/^.+\n/].strip


		end
	end
end
