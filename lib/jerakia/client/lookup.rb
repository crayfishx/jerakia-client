class Jerakia
  class Client
    module Lookup
      def lookup(key, params)

        ## Convert namespace array to forward slash delimited string
        if params[:namespace].is_a?(Array)
          params[:namespace] = params[:namespace].join('/')
        end

        if params[:scope_opts].is_a?(Hash)
          params[:scope_opts].each do |k,v|
            params["scope_#{k}".to_sym] = v
          end
          params.delete(:scope_opts)
        end
        if params[:metadata].is_a?(Hash)
          params[:metadata].each do |k,v|
            params["metadata_#{k}".to_sym] = v
          end
          params.delete(:metadata)
        end

        return get("/v1/lookup/#{key}", params)
      end
    end
  end
end
