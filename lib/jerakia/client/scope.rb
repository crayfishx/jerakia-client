class Jerakia
  class Client
    module Scope

      def send_scope(realm, identifier, scope)
        put("/v1/scope/#{realm}/#{identifier}", scope)
      end

      def get_scope_uuid(realm, identifier)
        get("/v1/scope/#{realm}/#{identifier}/uuid")
      end

      def get_scope(realm, identifier)
        get("/v1/scope/#{realm}/#{identifier}")
      end
    end
  end
end
