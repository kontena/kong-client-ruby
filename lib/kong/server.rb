module Kong
  class Server
    def self.version
      self.info['version'] rescue nil
    end

    def self.info
      Client.instance.info
    end

    def self.status
      Client.instance.status
    end

    def self.cluster
      Client.instance.cluster
    end

    def self.remove_node(name)
      Client.instance.remove_node(name)
    end
  end
end
