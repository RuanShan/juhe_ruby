require "open-uri"
require "json"

module Juhe

  module ExpressCompany
    BASE_URL = "http://v.juhe.cn/exp/com"

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def company_code_of(company_name, app_key = nil)
        app_key ||= Juhe.app_key
        result = JSON.parse(open(BASE_URL+"?key="+app_key).read)
        raise result["reason"] if result["resultcode"] != "200"

        result["result"].each do |company|
          return company["no"] if company["com"] == company_name
        end
      end
    end
  end

  module Express
    include ExpressCompany

    BASE_URL = "http://v.juhe.cn/exp/index"

    def self.search(company_name, number, app_key = nil)
      app_key ||= Juhe.app_key
      url = BASE_URL \
            + "?key=" \
            + app_key \
            + "&no=" + number \
            + "&com=" + company_code_of(company_name, app_key)

      result = JSON.parse(open(url).read)
      raise result["reason"].to_s if result["resultcode"] != "200"
      result["result"]
    end
  end


end
