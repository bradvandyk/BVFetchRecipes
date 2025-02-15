//
//  RecipeImageView.swift
//  FetchRecipes
//
//  Created by Brad Van Dyk on 2/7/25.
//

import SwiftUI

struct RecipeImageView: View {
    let photoUrlSmall: URL?
    let imageId: String?

    public var body: some View {
        AsyncImage(url: photoUrlSmall) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 100, height: 100)
            case .success(let image):
                // Check if the image is cached first
                if let cachedImage = loadCachedImage(url: photoUrlSmall, imageId: imageId) {
                    Image(uiImage: cachedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    // If not cached, display the downloaded image and cache it
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onAppear {
                            // Cache the image when it's successfully loaded
                            if let photoUrlSmall = photoUrlSmall, let imageId = imageId {
                                cacheImageToDisk(url: photoUrlSmall, image: image.asUIImage(), imageId: imageId)
                            }
                        }
                }
            case .failure(_):
                Image(systemName: "exclamationmark.triangle.fill")  // Show an error icon
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    // Utility function to cache images to disk
    func cacheImageToDisk(url: URL, image: UIImage, imageId: String) {
        let uniqueFileName = "\(imageId)_\(url.lastPathComponent)"

        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let filePath = cacheDirectory.appendingPathComponent(uniqueFileName)
        
        do {
            try data.write(to: filePath)
        } catch {
            print("Error caching image: \(error)")
        }
    }
    
    // Function to check the cache for an image
    func loadCachedImage(url: URL?, imageId: String?) -> UIImage? {
        guard let url = url else { return nil }
        guard let imageId = imageId else { return nil }
        let uniqueFileName = "\(imageId)_\(url.lastPathComponent)"
        
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let filePath = cacheDirectory.appendingPathComponent(uniqueFileName)
        
        return UIImage(contentsOfFile: filePath.path)
    }
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
