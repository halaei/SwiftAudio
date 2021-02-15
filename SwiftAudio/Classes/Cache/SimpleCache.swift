//
// Created by hamid on 2/15/21.
//

import Foundation

class SimpleCache: Cache {
    func release() {
        // todo
    }

    func getCachedSpans(key: String) -> [CacheSpan] {
        let resource = ResourceModel.find(key: key);
        if (resource == nil) {
            return [];
        }
        let spans = SpanModel.getCachedSpans(resourceId: resource![ResourceModel.id]);
        return spans.map { SpanModel.hydrate(row: $0, key: key)};
    }

    func getKeys() -> [String] {
        return ResourceModel.all().map { $0[ResourceModel.key] };
    }

    func getCacheSpace() -> Int64 {
        return SpanModel.size()
    }

    func startReadWrite(key: String, position: Int64, length: Int64?) throws -> CacheSpan {
        // todo
        return CacheSpan(key: key, position: position, length: 0, file: nil, lastTouchTimestamp: nil);
    }

    func startReadWriteNonBlocking(key: String, position: Int64, length: Int64?) throws -> CacheSpan? {
        // todo
        return nil;
    }

    func startFile(key: String, position: Int64, length: Int64?) throws -> FileHandle {
        // todo
        return FileHandle();
    }

    func commitFile(file: FileHandle, length: Int64) throws {
        // todo
    }

    func releaseHoleSpan(holeSpan: CacheSpan) {
        // todo
    }

    func removeResource(key: String) {
        // todo
    }

    func removeSpan(span: CacheSpan) {
        // todo
    }

    func isCached(key: String, position: Int64, length: Int64) -> Bool {
        // todo
        return false;
    }

    func getCachedLength(key: String, position: Int64, length: Int64?) -> Int64 {
        // todo
        return 0;
    }

    func getCachedBytes(key: String, position: Int64, length: Int64) -> Int64 {
        // todo
        return 0;
    }

}
