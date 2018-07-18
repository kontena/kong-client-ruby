require_relative "../spec_helper"

describe Kong::Util do
  describe '.flatten' do
    subject { described_class.method(:flatten) }

    it 'works' do
      expect(subject[{
        a: {
          b: 1,
          c: {
            d: 3
          }
        },
        b: 2
      }]).to include({
        "a.b" => 1,
        "a.c.d" => 3,
        "b" => 2,
      })
    end

    it 'accepts a scope' do
      expect(subject[{ a: "1" }, 'config']).to eq({
        "config.a" => "1"
      })
    end
  end
end
