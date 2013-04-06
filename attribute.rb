class AttributeLines

	def initialize(line)
		@lines = Array.new
		@lines << line
	end

	def add_line(line)
		@lines << line
	end
	
	def name
	   firstLine = @lines.first
	   firstLine[0, firstLine.index(':')]
	end
	
	def values
	   allLinesValues = Array.new
       
       firstLine = @lines.first
       firstLineValuesText = firstLine[firstLine.index(':') + 1,firstLine.length] 
       
       allLinesValues.concat(line_values(firstLineValuesText))
       for index in 1...@lines.size
            allLinesValues.concat(line_values(@lines[index]))
       end
        
       allLinesValues
	end
	
	def line_values(line)
	   values = Array.new
	   splittedValues = line.split(',')
       splittedValues.each do |value|
           value.strip!  
           unless(value.empty?)
                values << value
           end
       end
       values
	end

	def to_s
		"AttributeLines '#{name}' => #{values}"
	end

end
