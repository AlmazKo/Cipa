# coding: utf-8
require 'net/http'
require 'nokogiri'
require 'date'
module Cipa

  class Parser
    def initialize
      @http = Net::HTTP.new('www.cian.ru', 80)
      @headers = {
          "Accept" => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          "Accept-Charset" => "windows-1251,utf-8;q=0.7,*;q=0.3",
          "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.19 (KHTML, like Gecko) Ubuntu/12.04 Chromium/18.0.1025.168 Chrome/18.0.1025.168 Safari/535.19",
          "Referer" => "http://www.cian.ru/search.php?deal_type=1&objects=flats&obl_id=1"
      }

    end

    def download_page(params, path = '/cat.php?deal_type=1')
      data = URI.encode_www_form params
      resp, _ = @http.post(path, data, @headers)

      resp.body
    end


    def parse_search(response)
      result = []
      html = Nokogiri::HTML(response)

      html.css('tr').each do |flat|

        next unless flat.attr('id').to_s =~ /tr_(?<id>[0-9]+)/


        proposal = {id: $~[:id].to_i}

        flat.css('td').each do |td|
          type = td.attr('id').to_s

          case
            when type =~ /metro/
              anchors = td.css('a')
              proposal[:address] = anchors[0].content + ' ' + anchors[1].content
            when type =~ /room$/
              td.content =~ /^([0-9])/u
              proposal[:rooms] = $1.to_i
            when type =~ /rooms$/
              area = {}
              content = td.content

              area[:kitchen] = $1.to_i if content =~ /кухня: ([0-9]+)м/u
              area[:living] = $1.to_i if content =~ /жилая: ([0-9]+)м/u
              area[:total] = $1.to_i if content =~ /общая: ([0-9]+)м/u

              proposal[:area] = area

            when type =~ /_price$/

              raw_payment = td.children[0].to_s
              if raw_payment =~ /^([0-9]+),([0-9]+)/u
                proposal[:payment] = ($1 + $2).to_i
              end

            when type =~ /_comment$/

              raw_date = td.css('#added_' << proposal[:id].to_s)[0].content
              begin
                if raw_date =~ /^\d+:\d+$/
                  proposal[:date] = DateTime.strptime(raw_date, '%H:%M')
                else
                  proposal[:date] = DateTime.strptime(raw_date, '%d.%m.%y %H:%M')
                end
              rescue => ex
                 puts ex.message + " " + raw_date
              end


              info = []
              td.children.each do |el|
                if el.instance_of? Nokogiri::XML::Text
                    # strip - не подходит, т.к. не работает с UTF-пробелами (например &nbsp;)
                   row = el.to_s.strip.sub(/\p{Zs}+$/u, '')
                   info << row unless row.empty?
                end
              end

              proposal[:info] = info

          end

        end

        result << proposal
      end

      result
    end
  end
end