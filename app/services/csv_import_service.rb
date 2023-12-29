class CsvImportService
  def import_file(path)
    csv_contents = File.read(path)
    csv = CSV.parse(csv_contents)

    valid? csv

    csv.map do |row|
      parse_transaction(row)
    end
  end

  private

  def valid?(csv)
    raise StandardError, "invalid file provided" unless csv.present?
    raise StandardError, "empty file provided" if csv.count == 0
  end

  def parse_transaction(row)
    date = DateParserService.new.parse(row[0].strip)
    reference = row[1].strip
    amount = row[2].strip
    memo = row[3].strip

    {
      date: date,
      reference: reference,
      amount: amount,
      memo: memo
    }
  end
end