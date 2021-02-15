import Foundation
import SQLite

class ResourceModel {
    static let table = Table("resources");
    static let id = Expression<Int64>("id");
    static let key = Expression<String>("key");
    static let metadata = Expression<String>("metadata");
}
