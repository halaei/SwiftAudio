import Foundation
import SQLite

class ResourceModel {
    static let table = Table("resources");
    static let id = Expression<Int64>("id");
    static let key = Expression<String>("key");
    static let metadata = Expression<String>("metadata");

    static func all() -> [Row]
    {
        return Array(try! Database.getInstance().open().prepare(table));
    }

    static func find(key: String) -> Row?
    {
        return try! Database.getInstance().open().pluck(table.filter(self.key == key))
    }
}
