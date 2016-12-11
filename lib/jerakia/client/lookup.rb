class Jerakia
  class Client
    module Lookup
      def lookup(key, params)
        return get("/v1/lookup/#{key}", params)
      end
    end
  end
end
