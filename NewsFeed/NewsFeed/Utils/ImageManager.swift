//
//  ImageManager.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import UIKit
import ImageIO

protocol ImageManager {
    var image: UIImage? { get }
    func loadImage(url: URL, size: CGSize, scale: CGFloat)
    func cancel()
}

@Observable
final class ImageManagerBuilder: ImageManager {
    
    private(set) var image: UIImage?
    private static let cache = NSCache<NSString, UIImage>()
    
    private let imageDownloader: ImageDownloader
    init(imageDownloader: ImageDownloader = ImageDownloaderRepository()) {
        self.imageDownloader = imageDownloader
    }
    
    private var loadTask: Task<Void, Never>?
    
    func loadImage(url: URL, size: CGSize, scale: CGFloat) {
        if let cacheImage = Self.cache.object(forKey: url.absoluteString as NSString) {
            image = cacheImage
            return
        }
        
        loadTask?.cancel()
        
        loadTask = Task(priority: .utility) { [weak self] in
            guard let self else { return }
            
            do {
                let imageData = try await imageDownloader.loadImageData(url: url)
                guard !Task.isCancelled else { return }
                
                if let image = downsample(data: imageData,
                                          to: size,
                                          scale: scale) {
                    Self.cache.setObject(image, forKey: url.absoluteString as NSString)
                    await MainActor.run {
                        self.image = image
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancel() {
        loadTask?.cancel()
        loadTask = nil
    }
    
    private func downsample(data: Data, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let maxDimension = max(pointSize.width, pointSize.height) * scale

        let sourceOptions: [CFString: Any] = [
            kCGImageSourceShouldCache: false
        ]
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions as CFDictionary) else {
            return nil
        }

        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

protocol ImageDownloader {
    func loadImageData(url: URL) async throws -> Data
}

final class ImageDownloaderRepository: ImageDownloader {
    
    let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadImageData(url: URL) async throws -> Data {
        let (data, _) = try await session.data(for: URLRequest(url: url))
        return data
    }
}
