require 'csv'
require 'active_record/fixtures'
# gives Rails ability to load csv fixtures like before
class ActiveRecord::Fixtures
  class InvalidHeader < StandardError; end
  class InvalidRow    < StandardError; end

  private

  _read_fixture_files_ = instance_method(:read_fixture_files)

  # method overwrite
  define_method(:read_fixture_files) do
    if ::File.file?(csv_file_path)
      read_csv
    else
      _read_fixture_files_.bind(self).call
    end
  end

  def read_csv
    reader = ::CSV.parse(erb_render(IO.read(csv_file_path)))
    header = reader.shift
    raise(InvalidHeader, "#{csv_file_path} header contains blank values!") if header.any?(&:blank?)
    _header = header.map(&:strip)
    header_size = _header.size
    raise(InvalidHeader, "#{csv_file_path} header contains duplicate values!") if _header.uniq.size != header_size
    reader.each_with_index do |row,row_num|
      raise(InvalidRow, "#{csv_file_path} row ##{row_num+1} size doesn't match header size!") if row.size != header_size
      _row = row.map(&:presence).map{|value| value.try(:strip)}
      data = Hash[_header.zip(_row)]
      fixtures["#{@class_name.to_s.underscore}_#{row_num+1}"] = ::ActiveRecord::Fixture.new(data, model_class)
    end
  end

  def csv_file_path
    "#{@fixture_path}.csv"
  end  

  def erb_render(fixture_content)
    ERB.new(fixture_content).result
  end
end
