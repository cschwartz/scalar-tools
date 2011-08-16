require 'tuplelist' 
require 'logger'
require 'csv'

module ScalarTools
  def qualified_name(package, name)
    package == "." ? name : "#{package}.#{name}"
  end


  def extract_scalars(glob, values)
    log = Logger.new(STDOUT)

    Dir.glob(glob).each do |file_name|
      scalar_file = File.new file_name 
      scalar_file.each_line do |line|
        next unless line.start_with? "scalar"
        record_scalar_in line, :to => values
      end
      begin
        values.next
      rescue Exception => exception
        log.warn "Parsing '#{file_name}' produced exception '#{exception}'"
    end
  end

  def record_scalar_in(line, args)
    values = args.delete :to

    _, package, name, value = line.split
    property_name  = qualified_name package, name
    values[property_name] = value
  end

end

values = TupleList.new keys, :ignore => true

output = CSV.generate :headers => keys, :write_headers => true do |csv| 
  values.each { |row| csv << row }
end
puts output 

end
