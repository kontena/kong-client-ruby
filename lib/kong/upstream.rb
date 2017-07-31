module Kong
  class Upstream
    include Base

    ATTRIBUTE_NAMES = %w(id name slots orderlist).freeze
    API_END_POINT = '/upstreams/'.freeze

    ##
    # @return [Array<Kong::Target>]
    def targets
      targets   = []
      json_data = Client.instance.get("#{API_END_POINT}#{self.id}/targets")

      if json_data['data']
        json_data['data'].each do |target_data|
          target = Target.new(target_data)
          targets << target if target.active?
        end
      end

      targets
    end
  end
end
