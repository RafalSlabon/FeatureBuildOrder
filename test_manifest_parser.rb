require './manifest_parser'
require "test/unit"

class TestManifestParser < Test::Unit::TestCase

    def setup
        parser = ManifestParser.new
        
        content = "One-Value: 1.0\n"
        content += "Whitespace-Value: X Y Z\n"
        content += "One-Line-Many-Values: a,b,c,d\n"
        content += "Many-Lines-Many-Values: a,b,c,d\n"
        content += " e,f,g,h\n"
        content += " i,j,k,l\n"

        @manifest = parser.parse(content)
    end 
 
    def test_should_get_basic_attribute
        assert_equal("1.0", @manifest.get_attribute("One-Value")[0])
    end
    
    def test_should_get_attribute_with_whitespaces_in_value
        assert_equal("X Y Z", @manifest.get_attribute("Whitespace-Value")[0])
    end
    
    def test_should_get_attribute_many_lines_with_many_values
        assert_equal(12, @manifest.get_attribute("Many-Lines-Many-Values").size)
        assert_equal("a", @manifest.get_attribute("Many-Lines-Many-Values")[0])
        assert_equal("d", @manifest.get_attribute("Many-Lines-Many-Values")[3])
        assert_equal("l", @manifest.get_attribute("Many-Lines-Many-Values")[11])
    end
    
    def test_should_get_attribute_one_line_with_many_values
        assert_equal(4, @manifest.get_attribute("One-Line-Many-Values").size)
        assert_equal("a", @manifest.get_attribute("One-Line-Many-Values")[0])
        assert_equal("b", @manifest.get_attribute("One-Line-Many-Values")[1])
        assert_equal("c", @manifest.get_attribute("One-Line-Many-Values")[2])
        assert_equal("d", @manifest.get_attribute("One-Line-Many-Values")[3])
    end
 
end
