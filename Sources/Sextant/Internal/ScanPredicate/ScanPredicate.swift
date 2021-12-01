import Foundation
import Hitch

class ScanPredicate {
    class func create(target: PathToken, evaluationContext: EvaluationContext) -> ScanPredicate {
        if let target = target as? PropertyPathToken {
            return PropertyPathTokenPredicate(token: target,
                                              evaluationContext: evaluationContext)
        }
        if let target = target as? ArrayPathToken {
            return ArrayPathTokenPredicate(token: target)
        }
        if let target = target as? WildcardPathToken {
            return WildcardPathTokenPredicate(token: target)
        }
        if let target = target as? PredicatePathToken {
            return FilterPathTokenPredicate(token: target,
                                            evaluationContext: evaluationContext)
        }
        return FakePredicate()
    }
    
    func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return false
    }
}