# coding: utf-8
$:.unshift(File.dirname(__FILE__))
require 'parser'
require 'json'

class App
  include Cipa

  def initialize
    @cache = {}
    @parser = Parser.new
  end

  def example
    unless valid_cache? :example

      update_cache :example, get_example_data
    end

    get_cache :example
  end

  private

  def get_example_data
    @@params = {deal_type: 1, type: 1, id_user: '', room1: 1,
                type: -2, minprice: 25000, maxprice: 33000, currency: 2,
                maxprepay: 0, obl_id: 1, street: '', only_foot: 2, foot_min2: '',
                foot_min: 15, mebel: 0, phone: 0, rfgr: 0, tv: 0, wm: 0,
                minkarea: '', maxkarea: '', minlarea: '', maxlarea: '', minarea: '', maxarea: '',
                minfloor: '', maxfloor: '', minfloorn: '', maxfloorn: '', context: '', acontext: '', email: '',
                freq: 1, att_type: 1, sub_period: 1209600,
                in_polygon: '37.646125,55.847544,37.667755,55.850055,37.706722,55.876795,37.676853,55.892618,37.646297,55.895415,37.635997,55.881523,37.635825,55.864923,37.628787,55.853434,37.631019,55.84764'
    }
    response = @parser.download_page @@params

    response.encode!('UTF-8', 'WINDOWS-1251')

    @parser.parse_search response
  end

  def get_cache(key)
    @cache[key][:data]
  end

  def update_cache(key, data)
    @cache[key] = {time: Time.now.to_i, data: data}
  end

  def expire_cache?(key, expire_sec = 60)
    (@cache[key][:time] + expire_sec) > Time.now.to_i
  end

  def valid_cache?(key, expire_sec = 60)
    @cache[:example] && expire_cache?(key, expire_sec)
  end
end