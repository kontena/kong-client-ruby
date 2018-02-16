module Kong
  module Rootless
    module ClassMethods
      def find(id, opts={})
        raise NotImplementedError, 'Kong does not support direct access to this resource'
      end

      def list(params = {}, opts = {})
        raise NotImplementedError, 'Kong does not support direct access to this resource'
      end

      def all(params = {}, opts = {})
        raise NotImplementedError, 'Kong does not support direct access to this resource'
      end
    end
    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end