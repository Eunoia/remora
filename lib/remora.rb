require "remora/version"
require 'mechanize'
require 'nokogiri'

module Remora
	class Remora
		attr_accessor :cookies
		def initialize(u,p)
			@agent = Mechanize.new
			@agent.user_agent_alias = 'Mac Safari'
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
			address = doc.css(".header-address h2").text().strip()[/^.+\n/].strip

			report_sections = resp.search("script")
				.select{ |t| t.text[/psrk.ajaxLoader/] }
				.map{ |t| t.text[/mason[^"]+/] }
				.inject({}) do |memo, obj|
					name = obj[/name[^&]+/][/[\w_]+$/];
					memo[name.to_sym] = obj;
					memo
				end

			overview_response = @agent.get("http://www.propertyshark.com/"+report_sections[:overview])

			table1 = overview_response.search("table")[1]
			neighborhood = table1.css(".r_align").text()

			table2 = overview_response.search("table")[2]
			last_sale = {
				date:  table2.css(".r_align")[0].text(),
				price: table2.css(".r_align")[1].text()
			}

			table3 = overview_response.search("table")[3]
			owner = {
				name: table3.css(".r_align")[0].text(),
				address:table3.css(".r_align")[1].text(),
				line2: table3.css(".r_align")[2].text()
			}

			table5 = overview_response.search("table")[5]
			land = {
				lot_sq_ft: table5.css(".r_align")[0].text(),
				prop_class: table5.css(".r_align")[1].text(),
				depth: table5.css(".r_align")[2].text(),
				zoning: table5.css(".r_align")[3].text(),
			}

			table6 = overview_response.search("table")[6]
			building = {
				sq_ft: table6.css(".r_align")[0].text(),
				year_built: table6.css(".r_align")[1].text(),
			}

			overview = {
				address: address,
				neighborhood: neighborhood,
				last_sale: last_sale,
				owner: owner,
				land: land,
				building: building
			}
		end
	end
end
