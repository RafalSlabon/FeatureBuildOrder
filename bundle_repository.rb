require './manifest_parser'
require './manifest'

class Bundle

    def initialize(name)
        @name = name
        @required_bundles_name = Array.new
    end
    
    def name
        @name
    end
    
    def required_bundles_name
        @required_bundles_name
    end
    
    def add_required(name)
        @required_bundles_name << name
    end
    
    def to_s
        "Bundle: #{@name} required: #{@required_bundles_name}"
    end

end

class BundleRepository
    
    def initialize
        @bundles = Hash.new
        @manifestParser = ManifestParser.new
    end

    def find_bundles(dir)
        Dir.glob(dir + "/MANIFEST.MF") do |manifestPath|
            manifest = parse_manifest(manifestPath)
            bundle = bundle_from(manifest)
            @bundles[bundle.name] = bundle
        end
    end
    
    def find_bundle(bundleName)
        @bundles[bundleName]
    end
    
    def bundles
        @bundles
    end
    
    def parse_manifest(path)
        file = File.open(path, "rb")
        content = file.read
        manifest = @manifestParser.parse(content)
    end
    
    def bundle_from(manifest)
        bundleName = manifest.get_attribute("Bundle-Name")[0]
        bundle = Bundle.new(bundleName)
        
        required = manifest.get_attribute("Require-Bundle")
        if(required)
            required.each do |requiredBundleNameAndVersion|
                requiredBundleName = requiredBundleNameAndVersion[0, requiredBundleNameAndVersion.index(';')]
                bundle.add_required(requiredBundleName)
            end
        end
        bundle
    end

end
