import Foundation
import Hitch

class PropertyPathToken: PathToken {
    var properties: [Hitch]
    var wrap: UInt8

    init?(properties: [Hitch],
          wrap: UInt8) {
        if properties.count == 0 {
            error("Empty properties")
            return nil
        }

        self.properties = properties
        self.wrap = wrap
    }

    func singlePropertyCase() -> Bool {
        return properties.count == 1
    }

    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        guard let jsonObject = jsonObject as? JsonDictionary else {
            if isUpstreamDefinite() == false {
                return .done
            }
            return .error("Expected to find an object with property \(pathFragment()) in path \(currentPath) but found something that is not a json object.")
        }

        if singlePropertyCase() {
            return handle(properties: properties,
                          currentPath: currentPath,
                          jsonObject: jsonObject,
                          evaluationContext: evaluationContext)
        }

        for property in properties {
            let result = handle(properties: [property],
                                currentPath: currentPath,
                                jsonObject: jsonObject,
                                evaluationContext: evaluationContext)
            if result != .done {
                return result
            }
        }

        return .done
    }

    override func isTokenDefinite() -> Bool {
        // in case of leaf multiprops will be merged, so it's kinda definite
        return singlePropertyCase()
    }

    override func pathFragment() -> String {
        return "[\(properties.joined(delimiter: .comma, wrap: wrap))]"
    }
}
