require 'rexml/document'
include REXML

class Feature

    def initialize(name)
        @name = name
        @bundlesName = Array.new
        @requiresFeaturesName = Array.new
    end
    
    def name
        @name
    end
    
    def bundles_name
        @bundlesName
    end
    
    def add_bundle_name(bundleName)
        @bundlesName << bundleName
    end
    
    def required_features_name
        @requiresFeaturesName
    end
    
    def add_required_feature_name(featureName)
        @requiresFeaturesName << featureName
    end
    
    def to_s
        "Feature '#{@name}' has bundles: #{@bundlesName} and requires features: #{@requiresFeaturesName}"
    end

end

class FeatureRepository

    def initialize
        @features = Hash.new
        @bundles = Hash.new
    end

    def find_features(dir)
        Dir.glob(dir + "/feature.xml") do |featureXmlPath|
            feature = parse_feature_xml(featureXmlPath)
            @features[feature.name] = feature
        end
    end
    
    def parse_feature_xml(path)
        xml = Document.new(File.new(path) )
        featureName = xml.root.attributes["id"]
        feature = Feature.new(featureName)
        xml.elements.each("*/plugin") do |e| 
            bundleName = e.attributes["id"]
            feature.add_bundle_name(bundleName)
            @bundles[bundleName] = featureName
        end
        feature
    end
    
    def feature_name_for_bundle(bundleName)
        @bundles[bundleName]
    end
    
    def features
        @features
    end

end
