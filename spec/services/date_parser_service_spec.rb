require 'rails_helper'

RSpec.describe DateParserService do
  subject { DateParserService.new }

  describe "#parse" do
    let(:expected_result) { DateTime.parse('2023-02-15') }

    context '2023-02-15' do
      let(:date) { '2023-02-15' }

      it 'parses the date correctly' do
        result = subject.parse(date)
        expect(result).to eq(expected_result)
      end
    end

    context '15/02/2023' do
      let(:date) { '15/02/2023' }

      it 'parses the date correctly' do
        result = subject.parse(date)
        expect(result).to eq(expected_result)
      end
    end

    context '02/15/2023' do
      let(:date) { '02/15/2023' }

      it 'parses the date correctly' do
        result = subject.parse(date)
        expect(result).to eq(expected_result)
      end
    end
  end
end