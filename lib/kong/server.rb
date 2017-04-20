module Kong
  class Server
    def self.version
      self.info['version'] rescue nil
    end

    def self.info
      Client.instance.get('/')
    end

    def self.status
      Client.instance.get('/status')
    end

    def self.cluster
      Client.instance.get('/cluster')
    end

    def self.remove_node(name)
      Client.instance.delete("/cluster/nodes/#{name}")
    end
  end
end
