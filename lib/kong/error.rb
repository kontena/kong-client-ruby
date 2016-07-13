module Kong
  class Error < StandardError
    def initialize(status, message)
      @status = status
      super(message)
    end
  end
end
