//
//  CacheImageTests.swift
//  FetchRecipes
//
//  Created by Brad Van Dyk on 2/12/25.
//

import Foundation
@testable import FetchRecipes
import Testing
import UIKit

struct CacheImageTests {
    
    @Test
    func testImageCaching() {
        let photoUrl = URL(string: "https://example.com/image.jpg")!
        let imageId = "test_image_id"
        let view = RecipeImageView(photoUrlSmall: photoUrl, imageId: imageId)
        
        // Simulate the image loading success with a mock image
        let mockImage = UIImage(systemName: "star.fill")!
        
        // Manually trigger the caching behavior
        view.cacheImageToDisk(url: photoUrl, image: mockImage, imageId: imageId)
        
        // Verify that the image is cached
        let cachedImage = view.loadCachedImage(url: photoUrl, imageId: imageId)
        
        #expect(cachedImage != nil, "The image should be cached successfully.")
//        #expect(imagesAreEqual(cachedImage!, mockImage), "The cached image should match the expected mock image.")
    }

    func imagesAreEqual(_ image1: UIImage, _ image2: UIImage) -> Bool {
        guard let cgImage1 = image1.cgImage, let cgImage2 = image2.cgImage else {
            return false
        }
        
        // Compare the pixel data directly
        guard cgImage1.width == cgImage2.width, cgImage1.height == cgImage2.height else {
            return false
        }
        
        // Extract raw pixel data
        guard let data1 = cgImage1.dataProvider?.data,
              let data2 = cgImage2.dataProvider?.data else {
            return false
        }
        
        // Compare the data bytes
        return data1 == data2
    }
}
