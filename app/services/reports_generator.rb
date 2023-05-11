require 'csv'
class ReportsGenerator
  attr_reader :result

  def to_csv(filepath = nil)
    result = self.result || call
    return if result.empty?

    filepath ||= "tmp/#{SecureRandom.hex(5)}.csv"
    CSV.open(filepath, 'wb',
             write_headers: true,
             headers: result.first.keys) do |csv|
      result.each { |line| csv << line.values }
    end
    filepath
  end
end
