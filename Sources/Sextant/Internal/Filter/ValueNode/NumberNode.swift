import Foundation
import Hitch

fileprivate let typeHitch = Hitch("number")

struct NumberNode: ValueNode, Equatable {
    static let zero = NumberNode(value: 0)
    
    static func == (lhs: NumberNode, rhs: NumberNode) -> Bool {
        return lhs.intValue == rhs.intValue && lhs.doubleValue == rhs.doubleValue
    }
    
    private var intValue: Int? = nil
    private var doubleValue: Double? = nil
    
    init<T: FixedWidthInteger>(value: T) {
        self.intValue = Int(value)
    }
    
    init(value: Double) {
        self.doubleValue = value
    }
    
    init(value: Float) {
        self.doubleValue = Double(value)
    }
    
    init(hitch: Hitch) {
        self.intValue = hitch.toInt()
        self.doubleValue = hitch.toDouble()
    }
    
    var description: String {
        if let value = intValue {
            return value.description
        }
        if let value = doubleValue {
            return value.description
        }
        return Double.nan.description
    }
    
    var literalValue: Hitch? {
        return description.hitch()
    }
    
    var numericValue: Double? {
        if let double = doubleValue {
            return double
        }
        if let int = intValue {
            return Double(int)
        }
        return nil
    }
    
    var typeName: Hitch {
        return typeHitch
    }
}
