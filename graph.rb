require 'set'

class Edges
    def initialize
        @incoming = Set.new
        @outgoing = Set.new
    end
    
    def incoming
        @incoming
    end
    
    def outgoing
        @outgoing
    end
    
    def add_incoming(node)
        @incoming << node
    end
    
    def remove_incoming(node)
        @incoming.delete(node)
    end
    
    def has_any_incoming?
        !@incoming.empty?
    end
    
    def has_incoming?(node)
         @incoming.include?(node)
    end
    
    def has_outgoing?(node)
         @outgoing.include?(node)
    end
    
    def add_outgoing(node)
        @outgoing << node
    end
    
    def remove_outgoing(node)
        @outgoing.delete(node)
    end
    
    def to_s
        "Edges incoming:#{@incoming} outgoing:#{@outgoing}"
    end

end

class Graph

    def initialize
        @nodes = Hash.new
    end
    
    def add_vertex(vertex)
        @nodes[vertex] = Edges.new
    end
    
    def add_edge(src, dst)
        src_edges = @nodes[src]
        src_edges.add_outgoing(dst)
        @nodes[src] = src_edges
        
        dst_edges = @nodes[dst]
        dst_edges.add_incoming(src)
        @nodes[dst] = dst_edges
    end
    
    def remove_edge(src, dst)
        src_edges = @nodes[src]
        dst_edges = @nodes[dst]
        if(!src_edges.has_outgoing?(dst) || !dst_edges.has_incoming?(src))
            raise "there is no edge from '#{src}' to '#{dst}'!"
        end
        
        src_edges.remove_outgoing(dst)           
        dst_edges.remove_incoming(src)
    end
    
    def nodes
        @nodes
    end
    
    def has_edges?
        @nodes.each_value do |edges|
            if(!edges.incoming.empty? || !edges.outgoing.empty?)
                return true
            end
        end
        return false 
    end
    
    def incoming_nodes_of(node)
        @nodes[node].incoming
    end
    
    def outgoing_nodes_of(node)
        @nodes[node].outgoing
    end
    
    def to_s
        "Graph: #{@nodes}"
    end
    
end

class TopologicalSort

    def initialize(graph)
        @graph = graph
    end
    
    #http://en.wikipedia.org/wiki/Topological_sorting
    def sort
        sortedNodes = Array.new
        s = nodes_with_no_incoming_edges
        s.each do |n|
            sortedNodes << n
            outgoingNodesOfN = @graph.outgoing_nodes_of(n)
            outgoingNodesOfN.each do |m|
                @graph.remove_edge(n, m)
                incomingNodesOfM = @graph.incoming_nodes_of(m)
                if(incomingNodesOfM.empty?)
                    s << m
                end
            end
        end
        
        if(@graph.has_edges?)
            raise "graph has at least one cycle"
        end
        sortedNodes
    end
    
    def nodes_with_no_incoming_edges
        nodesWithNoIncomingEdges = Set.new
        
        @graph.nodes.each do |node, edges|
            unless(edges.has_any_incoming?)
                nodesWithNoIncomingEdges << node
            end
        end
        nodesWithNoIncomingEdges.to_a 
    end

end
