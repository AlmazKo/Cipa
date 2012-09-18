# coding: utf-8
$:.unshift(File.dirname(__FILE__))
require 'lib/parser'
require 'json'

params = {
    deal_type: 1,
    type: 1,
    id_user: '',
    room1: 1,
    type: -2,
    minprice: 25000,
    maxprice: 33000,
    currency: 2,
    maxprepay: 0,
    obl_id: 1,
    street: '',
    only_foot: 2,
    foot_min2: '',
    foot_min: 15,
    mebel: 0,
    phone: 0,
    rfgr: 0,
    tv: 0,
    wm: 0,
    minkarea: '',
    maxkarea: '',
    minlarea: '',
    maxlarea: '',
    minarea: '',
    maxarea: '',
    minfloor: '',
    maxfloor: '',
    minfloorn: '',
    maxfloorn: '',
    context: '',
    acontext: '',
    email: '',
    freq: 1,
    att_type: 1,
    sub_period: 1209600,
    #metro: [106],
    in_polygon: ['37.634109,55.800773,37.653678,55.805317,37.668613,55.821943,37.646125,55.828321,37.618659,55.829287,37.616771,55.813534']
}



include Cipa
parser = Parser.new


response = parser.download_page params

response.encode!('UTF-8', 'WINDOWS-1251')

File.open('temp', 'w+') do |file|
  file.write response
end

flats = parser.parse_search response


#flats.each do |flat|
#  printf "[%s] %s (%s)\n" % [flat[:id], flat[:address], flat[:payment] ]
#end

puts flats.to_json

