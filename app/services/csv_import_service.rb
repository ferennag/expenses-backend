class CsvImportService
  def import_file(path)
    csv_contents = File.read(path)
    csv = CSV.parse(csv_contents)
    csv.map do |row|
      pp parse_transaction(row)
    end
  end

  private

  def parse_transaction(row)
    date = DateParserService.new.parse(row[0].strip)
    reference = row[1].strip
    amount = row[2].strip
    memo = row[3].strip

    Transaction.new({
                      date: date,
                      reference: reference,
                      amount: amount,
                      memo: memo
                    })
  end
end