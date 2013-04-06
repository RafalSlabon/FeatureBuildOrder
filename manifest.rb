class Manifest

    def initialize()
		@attributes = Hash.new
	end
	
	def put_attribute(name,values)
	    @attributes[name] = values 
	end
	
	def get_attribute(name)
	    @attributes[name]
	end
	
	def attributes
	    @attributes
	end
	
	def to_s
	    "Manifest #{@attributes}"
	end

end
