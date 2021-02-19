//
// Created by hamid on 2/18/21.
//

import Foundation
import DVAssetLoaderDelegate

class AssetLoaderDelegate: NSObject, DVAssetLoaderDelegatesDelegate {
    let url: DVURLAsset;

    init(url: DVURLAsset) {
        self.url = url;
    }

    func dvAssetLoaderDelegate(_ loaderDelegate: DVAssetLoaderDelegate!, didLoad data: Data!, for range: NSRange, url: URL!) {
        //NSLog("did load \(data.count) for range \(range.location) \(range.length)")
    }

    func dvAssetLoaderDelegate(_ loaderDelegate: DVAssetLoaderDelegate!, didLoad data: Data!, for url: URL!) {
        //NSLog("Did load \(data.count) for url \(url.absoluteString)")
    }

    func dvAssetLoaderDelegate(_ loaderDelegate: DVAssetLoaderDelegate!, didLoad data: Data!, for url: URL!, withMIMEType mimeType: String!) {
        //NSLog("Did load \(data.count) with mime \(mimeType ?? "unknown")")
    }

    func dvAssetLoaderDelegate(_ loaderDelegate: DVAssetLoaderDelegate!, didRecieveLoadingError error: Error!, with dataTask: URLSessionDataTask!, for request: AVFoundation.AVAssetResourceLoadingRequest!) {
        //NSLog("Did receive error")
    }
}
