import Foundation
import SQLite

class SpanModel {
    static let table = Table("spans");

    /// [resource.id].[position].[timestamp].[version].media
    static let name = Expression<String>("name");
    static let length = Expression<Int64>("length");
    static let last_touch_timestamp = Expression<Int64>("last_touch_timestamp");

    static func size() -> Int64
    {
        try! Database.getInstance().open().scalar(table.select(length.sum)) ?? 0
    }

    static func getCachedSpans(resourceId: Int64) -> Array<Row> {
        return Array(try! Database.getInstance().open().prepare(table.filter(name.like("\(resourceId).%"))));
    }

    static func hydrate(row: Row, key: String) -> CacheSpan {
        let regex = try? NSRegularExpression(pattern: "^(\\d+)\\.(\\d+)\\.(\\d+)\\.media$");
        let match = regex?.firstMatch(in: row[name], range: NSRange(0..<row[name].utf16.count))
        let position = Int64(row[name][Range((match?.range(at: 1))!, in: row[name])!])!;
        let file = FileHandle();

        return CacheSpan(
                key: key,
                position: position,
                length: row[length],
                file: file,
                lastTouchTimestamp: row[last_touch_timestamp]
        );
    }
}
