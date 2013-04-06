require './attribute'
require './manifest'

class ManifestParser

	def parse(content)
		read_manifest_entries(content)
		create_manifest_from_entries
	end
	
	private
	
	def read_manifest_entries(content)
	    @entries = Array.new
		content.each_line do |line|
			if(line.start_with?(" "))
				attribute = @entries.last
				attribute.add_line(line)
			else
				@entries << AttributeLines.new(line)
			end
		end
	end
	
	def create_manifest_from_entries
	    manifest = Manifest.new
		@entries.each do |entry| 
		    manifest.put_attribute(entry.name, entry.values)
		end
		manifest
	end
end
