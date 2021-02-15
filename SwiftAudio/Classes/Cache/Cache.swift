import Foundation

protocol Cache {

    ///
    /// Releases the cache. This method must be called when the cache is no longer required. The cache
    // must not be used after calling this method.
    // This method may be slow and shouldn't normally be called on the main thread.
    func release();

    ///
    /// Returns the cached spans for a given resource.
    /// - Parameter key: The cache key of the resource.
    /// - Returns: The spans for the key.
    func getCachedSpans(key: String) -> [CacheSpan];

    ///
    ///
    /// - Returns: The cache keys of all of the resources that are at least partially cached.
    func getKeys() -> [String];

    ///
    ///
    /// - Returns: the total disk space in bytes used by the cache.
    func getCacheSpace() -> Int64;

    /**
     * A caller should invoke this method when they require data starting from a given position in a
     * given resource.
     *
     * If there is a cache entry that overlaps the position, then the returned CacheSpan
     * defines the file in which the data is stored. CacheSpan.isCached is true. The caller
     * may read from the cache file, but does not acquire any locks.
     *
     * If there is no cache entry overlapping position, then the returned CacheSpan
     * defines a hole in the cache starting at position into which the caller may write as it
     * obtains the data from some other source. The returned CacheSpan serves as a lock.
     * Whilst the caller holds the lock it may write data into the hole. It may split data into
     * multiple files. When the caller has finished writing a file it should commit it to the cache by
     * calling commitFile(File, long). When the caller has finished writing, it must release
     * the lock by calling releaseHoleSpan.
     *
     * This method may be slow and shouldn't normally be called on the main thread.
     - Parameters:
       - key: key The cache key of the resource.
       - position: The starting position in the resource from which data is required.
       - length: The length of the data being requested, or nil if unbounded.
                 The length is ignored if there is a cache entry that overlaps the position. Else, it
                 defines the maximum length of the hole CacheSpan that's returned. Cache
                 implementations may support parallel writes into non-overlapping holes, and so passing the
                 actual required length should be preferred to passing nil when possible.
     - Returns: The {@link CacheSpan}.
     - Throws: InterruptedException If the thread was interrupted.
               CacheException If an error is encountered.
     */
    func startReadWrite(key: String, position: Int64, length: Int64?) throws -> CacheSpan;

    /**
     Same as startReadWrite. However, if the cache entry is locked,
     then instead of blocking, this method will return nil.
     - Returns: The CacheSpan. Or nil if the cache entry is locked.
     */
    func startReadWriteNonBlocking(key: String, position: Int64, length: Int64?) throws -> CacheSpan?;

    /**
     * Obtains a cache file into which data can be written. Must only be called when holding a
     * corresponding hole {@link CacheSpan} obtained from {@link #startReadWrite(String, long, long)}.
     *
     * <p>This method may be slow and shouldn't normally be called on the main thread.
     - Parameters:
       - key: The cache key of the resource being written.
       - position: The starting position in the resource from which data will be written.
       - length: The length of the data being written, or nil if unknown. Used
                 only to ensure that there is enough space in the cache.
     - Returns: The file into which data should be written.
     - Throws: CacheException If an error is encountered.
     */
    func startFile(key: String, position: Int64, length: Int64?) throws -> FileHandle;

    /**
     * Commits a file into the cache. Must only be called when holding a corresponding hole {@link
     * CacheSpan} obtained from {@link #startReadWrite(String, long, long)}.
     *
     * <p>This method may be slow and shouldn't normally be called on the main thread.
     *

     - Parameters:
       - file: A newly written cache file.
       - length: The length of the newly written cache file in bytes.
     - Throws: CacheException If an error is encountered.
     */
    func commitFile(file: FileHandle, length: Int64) throws;

    /**
     * Releases a CacheSpan obtained from startReadWrite which
     * corresponded to a hole in the cache.
     *
     - Parameter holeSpan: The CacheSpan being released.
     */
    func releaseHoleSpan(holeSpan: CacheSpan);

    /**
     * Removes all {@link CacheSpan CacheSpans} for a resource, deleting the underlying files.

     - Parameter key: The cache key of the resource being removed.
     */
    func removeResource(key: String);

    /**
     Removes a cached CacheSpan from the cache, deleting the underlying file.

     - Parameter span: The CacheSpan to remove.
     */
    func removeSpan(span: CacheSpan);

    /**
     Returns whether the specified range of data in a resource is fully cached.
     - Parameters:
       - key: The cache key of the resource.
       - position: The starting position of the data in the resource.
       - length: The length of the data.
     - Returns: true if the data is available in the Cache otherwise false;
     */
    func isCached(key: String, position: Int64, length: Int64) -> Bool;

    /**
     * Returns the length of continuously cached data starting from position, up to a maximum
     * of maxLength, of a resource. If position isn't cached then -holeLength
     * is returned, where holeLength is the length of continuously uncached data starting from
     * position, up to a maximum of maxLength.

     - Parameters:
       - key: The cache key of the resource.
       - position: The starting position of the data in the resource.
       - length: The maximum length of the data or hole to be returned. nil is
            permitted, and is equivalent to passing INT64_MAX.
     - Returns: The length of the continuously cached data, or -holeLength if position isn't cached.
     */
    func getCachedLength(key: String, position: Int64, length: Int64?) -> Int64;

    /**
     Returns the total number of cached bytes between {@code position} (inclusive) and {@code
     (position + length)} (exclusive) of a resource.

     - Parameters:
       - key: The cache key of the resource.
       - position: The starting position of the data in the resource.
       - length: The length of the data to check. nil is permitted, and is
           equivalent to passing INT64_MAX.
      - Returns: The total number of cached bytes.
     */
    func getCachedBytes(key: String, position: Int64, length: Int64) -> Int64;
}
