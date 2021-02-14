import Foundation

class CacheSpan {
    /* The cache key that uniquely identifies the resource. */
    var key: String;
    /* The position of the CacheSpan in the resource. */
    var position: UInt64;
    /* The length of the CacheSpan, or nil if this is an open-ended hole. */
    var length: UInt64?;
    /** Whether the CacheSpan is cached. */
    var isCached: Bool;
    /* The file corresponding to this CacheSpan, or nil if isCached is false. */
    var file: FileHandle?;
    /* The last touch timestamp, or nil if isCached is false. */
    var lastTouchTimestamp: UInt64?;

    init(key: String, position: UInt64, length: UInt64?, file: FileHandle?, lastTouchTimestamp: UInt64?) {
        self.key = key
        self.position = position
        self.length = length
        self.isCached = file != nil;
        self.file = file
        self.lastTouchTimestamp = lastTouchTimestamp
    }

    /* Returns whether this is an open-ended CacheSpan. */
    func isOpenEnded() -> Bool
    {
        length == nil;
    }

    /* Returns whether this is a hole CacheSpan. */
    func isHoleSpan() -> Bool
    {
        !isCached;
    }
}
