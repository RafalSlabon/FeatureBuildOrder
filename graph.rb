require 'set'

class Graph

    def initialize
        @nodes = Hash.new
    end
    
    def add_vertex(vertex)
        @nodes[vertex] = Array.new
    end
    
    def add_edge(src, dst)
        childOfSrc = @nodes[src]
        unless(childOfSrc)
            childOfSrc = Array.new
        end
        childOfSrc << dst
        @nodes[src] = childOfSrc
    end
    
    def remove_edge(src, dst)
        childOfSrc = @nodes[src]
        if(childOfSrc)
            childOfSrc.delete(dst)
        end
    end
    
    def nodes
        @nodes
    end
    
    def src_nodes_for(dst)
        srcNodes = Array.new
        @nodes.each do |srcNode, dstNodes|
            if(dstNodes.include?(dst))
                srcNodes << srcNode
            end
        end
        srcNodes
    end
    
    def to_s
        "Graph: #{@nodes}"
    end
    
end


class TopologicalSort

    def initialize(graph)
        @graph = graph
    end
    
    def sort
        sortedNodes = Array.new
        s = nodes_with_no_incoming_edges
        s.each do |node|
            s.delete(node)
            sortedNodes << node
            childNodes = @graph.src_nodes_for(node)
            childNodes.each do |childNode|
                @graph.remove_edge(node, childNode)
                childIncomingNodes = @graph.nodes[childNode]
                if(childIncomingNodes == nil || childIncomingNodes.empty?)
                    s << childNode
                end
            end
        end
        
        unless(@graph.nodes)
            throw "graph has at least one cycle"
        end
        sortedNodes
    end
    
    def nodes_with_no_incoming_edges
        nodesWithNoIncomingEdges = Set.new
        
        @graph.nodes.each do |node, childNodes|
            if(!childNodes || childNodes.empty?)
                nodesWithNoIncomingEdges << node
            end
        end
        nodesWithNoIncomingEdges 
    end

end

g = Graph.new
g.add_vertex("a")
g.add_vertex("b")
g.add_vertex("c")
g.add_vertex("d")

g.add_edge("a", "b")
g.add_edge("a", "c")

g.add_edge("b", "d")

#puts g

topSort = TopologicalSort.new(g)
puts topSort.sort

s = Set.new

s << "a"
i = 10
s.each do |x|
    if(i > 0)
        s << i.to_s
        i -= 1
    end
    puts s    
end

