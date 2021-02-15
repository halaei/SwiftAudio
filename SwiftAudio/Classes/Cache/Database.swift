import Foundation
import SQLite
// todo: proper exception handling try!?
// todo: retry migration
// todo: flush database and storage on migration error

class Database {

    private static var instance: Database?;

    public static func getInstance() -> Database {
        if (self.instance == nil) {
            self.instance = Database();
        }
        return self.instance!;
    }

    var db: Connection?;

    func open() -> Connection {
        if (db === nil) {
            let path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory, .userDomainMask, true
            ).first!
            db = try! Connection("\(path)/db.sqlite3")
            try! db?.run("PRAGMA temp_store = 1")
            try! db?.run("PRAGMA journal_mode = WAL")
            migrate();
        }
        return db!;
    }

    fileprivate func migrate() {
        if (userVersion < 1) {
            try! db?.run(ResourceModel.table.create { t in
                t.column(ResourceModel.id, primaryKey: true)  // Auto-incrementing id
                t.column(ResourceModel.key, unique: true)     // key
                t.column(ResourceModel.metadata)
            })
            try! db?.run(SpanModel.table.create { t in
                t.column(SpanModel.name, primaryKey: true)
                t.column(SpanModel.length)
                t.column(SpanModel.last_touch_timestamp)
            })
            userVersion = 1;
        }
    }

    fileprivate var userVersion: Int32 {
        get { return Int32(try! db?.scalar("PRAGMA user_version") as! Int64)}
        set { try! db?.run("PRAGMA user_version = \(newValue)") }
    }
}
