require './graph'
require 'test/unit'
require 'set'

class TestManifestParser < Test::Unit::TestCase

    def setup
        @graph = Graph.new
        @graph.add_vertex("a")
        @graph.add_vertex("b")
        @graph.add_vertex("c")
        @graph.add_vertex("d")
        
        @topSort = TopologicalSort.new(@graph)
    end
    
    def test_should_add_edges
        @graph.add_edge("a", "b")
        
        assert_equal(true, @graph.has_edges?)
        
        assert_equal(true, @graph.nodes["b"].has_any_incoming?)
        assert_equal(["a"].to_set, @graph.incoming_nodes_of("b"))
        assert_equal(Set.new, @graph.incoming_nodes_of("a"))
        
        assert_equal(false, @graph.nodes["a"].has_any_incoming?)
        assert_equal(["b"].to_set, @graph.outgoing_nodes_of("a"))
        assert_equal(Set.new, @graph.outgoing_nodes_of("b"))
    end 
    
    def test_should_empty_graph_has_no_edges
        assert_equal(false, @graph.has_edges?)
    end 
    
    def test_should_remove_existing_edge
        @graph.add_edge("a", "b")
        assert_equal(true, @graph.has_edges?)
        
        @graph.remove_edge("a", "b")
        assert_equal(false, @graph.has_edges?)
    end
 
    def test_should_sort_by_topological_order
        @graph.add_vertex("a")
        @graph.add_vertex("b")
        @graph.add_vertex("c")
        @graph.add_vertex("d")

        @graph.add_edge("a", "b")
        @graph.add_edge("a", "c")
        @graph.add_edge("c", "d")
        
        assert_equal(["a", "b", "c", "d"], @topSort.sort)
    end
 
end
