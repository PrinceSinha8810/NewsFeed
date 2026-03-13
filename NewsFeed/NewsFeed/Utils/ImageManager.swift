//
//  ImageManager.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import UIKit

protocol ImageManager {
    var image: UIImage? { get }
    func loadImage(url: URL)
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
    
    func loadImage(url: URL) {
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
                
                if let image = UIImage(data: imageData) {
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
