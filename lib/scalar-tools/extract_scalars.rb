require 'tuplelist' 
require 'logger'
require 'csv'

module ScalarTools
  class << self
    def extract_scalars(files, values)
      log = Logger.new(STDOUT)

      files.each do |file_name|
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
    end

    def record_scalar_in(line, args)
      values = args.delete :to

      _, package, name, value = line.split
      property_name  = qualified_name package, name
      values[property_name] = value
    end

    def qualified_name(package, name)
      package == "." ? name : "#{package}.#{name}"
    end
  end
end
