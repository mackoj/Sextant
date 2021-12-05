import Foundation
import Hitch

fileprivate let typeHitch = Hitch("json")


class JsonNode: ValueNode {
    static func == (lhs: JsonNode, rhs: JsonNode) -> Bool {
        return false //lhs.jsonString == rhs.jsonString && lhs.json == rhs.json
    }
    
    let jsonString: Hitch?
    let json: JsonAny
        
    init(hitch: Hitch) {
        self.jsonString = hitch
        self.json = nil
    }
    
    init(jsonObject: JsonAny) {
        self.jsonString = nil
        self.json = jsonObject
    }
    
    override var description: String {
        if let jsonString = jsonString {
            return jsonString.description
        }
        
        if let json = json,
           let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
           let string = String(data: data, encoding: .utf8){
            return string
        }
        return "null"
    }
        
    override var typeName: Hitch {
        return typeHitch
    }
}
