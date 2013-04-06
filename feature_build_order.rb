require './bundle_repository'
require './feature_repository'

#gem install rgl
require 'rgl/adjacency'
require 'rgl/traversal'
require 'rgl/dot'


class FeatureBuildOrder

    def initialize
        @bundleRepo = BundleRepository.new
        @featureRepo = FeatureRepository.new
        @featureGraph=RGL::DirectedAdjacencyGraph.new
    end

    def order
        @bundleRepo.find_bundles("**")
        @featureRepo.find_features("**")
        assign_required_features
        create_feature_graph
        
         @featureRepo.features.each_value do |feature|
            features =  @featureGraph.bfs_iterator(feature)
            features.each do |x|
                puts x
            end
        end
        
        @featureGraph.write_to_graphic_file(fmt='png')  
    end
    
    def assign_required_features
        @featureRepo.features.each_value do |feature|
            feature.bundles_name.each do |bundleName|
                bundle = @bundleRepo.find_bundle(bundleName)
                bundle.required_bundles_name.each do |requiredBundleName|
                    requiredFeatureName = @featureRepo.feature_name_for_bundle(requiredBundleName)
                    if(requiredFeatureName)
                        feature.add_required_feature_name(requiredFeatureName)
                    else
                       puts "Missing feature for bundle: #{requiredBundleName}"     
                    end
                end        
            end
        end
    end
    
    def create_feature_graph
        @featureRepo.features.each_value do |feature|
            @featureGraph.add_vertex(feature)
            feature.required_features_name.each do |required_feature_name|
                required_feature = @featureRepo.features[required_feature_name]
                @featureGraph.add_edge(required_feature, feature)
            end 
        end
    end
end

o = FeatureBuildOrder.new
o.order
