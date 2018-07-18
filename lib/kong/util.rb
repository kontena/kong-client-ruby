module Kong
  module Util
    def self.flatten(cursor, parent_key = nil, memo = {})
      memo.tap do
        case cursor
        when Hash
          cursor.keys.each do |key|
            flatten(cursor[key], [parent_key, key].compact.join('.'), memo)
          end
        else
          memo["#{parent_key}"] = cursor
        end
      end
    end
  end
end
