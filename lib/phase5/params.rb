require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params
      unless req.query_string.nil?
        if req.query_string.include?('%5B')
          q_hash = parse_www_encoded_form(req.query_string)
          @params.merge!(q_hash)
        else
          @params.merge!(URI::decode_www_form(req.query_string).to_h)
        end
      end
      unless req.body.nil?
        if req.body.include?('%5B')
          b_hash = parse_www_encoded_form(req.body)
          @params.merge!(b_hash)
        else
          ary = URI::decode_www_form(req.body)
          @params.merge!(ary.to_h)
        end
      end
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      keys = URI.unescape(www_encoded_form)
      keys = keys.split('&')
      hashes = keys.map{ |key| parse_key(key) }.map{ |ary| ary.reverse.inject{ |all, x| {x => all} }}
      hashes.inject{ |x, y| x.deep_merge(y) }
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      keys = key.split(/\]\[|\[|\]\=/)
    end
  end
end
