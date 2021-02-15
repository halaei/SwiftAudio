import Foundation
import SQLite

class SpanModel {
    static let table = Table("spans");
    static let name = Expression<String>("name");
    static let length = Expression<Int64>("length");
    static let last_touch_timestamp = Expression<Int64>("last_touch_timestamp");
}
