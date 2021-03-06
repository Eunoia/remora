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
			raise StandardError, ("No username, or password") if (u||p).nil?
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
			begin 
				doc
					.css(".my-subscriptions")[0]
					.css(".details span")[-3]
					.text().strip
			rescue NoMethodError => error
				"0/200"
			end
		end
		def search_in_sf(address)
			response = @agent.get("http://www.propertyshark.com/mason/ca/San-Francisco-County/Property-Search")
			search_form = {
				search_type:"address",
				search_types_selector:"address",
				search_token: address,
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
		def search_by_name_in_sf(name)
			response = @agent.get("http://www.propertyshark.com/mason/ca/San-Francisco-County/Property-Search")

			search_form = {
				search_type:"owner",
				search_types_selector:"owner",
				search_token: name,
				location:"San Francisco County, CA"
			}
			
			request_search_by_name(search_form)
		end
		def search_by_name_in_la(name)
			response = @agent.get("http://www.propertyshark.com/mason/ca/Los-Angeles-County/Property-Search")

			search_form = {
				search_type:"owner",
				search_types_selector:"owner",
				search_token: name,
				location:"Los Angeles County, CA"
			}
			request_search_by_name(search_form)
		end
		def search_by_name_in_alameda(name)
			response = @agent.get("http://www.propertyshark.com/mason/ca/Alameda-County/Property-Search")

			search_form = {
				search_type:"owner",
				search_types_selector:"owner",
				search_token: name,
				location:"Alameda County, CA"
			}
			request_search_by_name(search_form)
		end
		private
		def request_search_by_name(search_form)
			resp = @agent.post("http://www.propertyshark.com/mason/UI/homepage_search.html",search_form)

			doc = Nokogiri::parse(resp.body)

			results = doc.search(".owner_table tr.odd, .owner_table tr.even").reject{ |r| r[:style]=~/display:none/ }



			results.map do |result|
				{
					address: result.css("td.first span.big_font").text().strip(),
					city:   (result.css("td.first b").text().split(",").shift()||"").strip(),
					owner:  result.css(".single_line:first-child").text().strip()
				}
			end
		end
	end
end
