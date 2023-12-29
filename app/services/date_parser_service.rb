class DateParserService
  class UnsupportedFormatError < StandardError; end

  SUPPORTED_FORMATS = %w[
      %Y-%m-%dT%H:%M:%S%z
      %Y-%m-%d
      %m/%d/%Y
      %d/%m/%Y
      %m-%d-%Y
      %d-%m-%Y
    ].freeze

  def parse(str)
    result = SUPPORTED_FORMATS.map do |format|
      begin
        DateTime.strptime(str, format)
      rescue Date::Error
        nil
      end
    end

    date = result.find { |date| date.present? }

    raise UnsupportedFormatError unless date.present?

    date
  end
end