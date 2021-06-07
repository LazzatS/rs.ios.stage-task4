import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        
        var newImage = image                        // create a copy of the given image to be able to change it
        let mainPixel = image[row][column]          // take initial pixel
        
        for pixel in 0..<image.count {              // check every pixel
            let m = image.count                     // number of rows
            let n = image[pixel].count              // number of columns
            
            // follow given constraints
            if m < 1 || n > 50 || image[row][column] < 0 || newColor >= 65536 || row < 0 || row > m || column < 0 || column > n {
                return image                        // return original image
            }
        }
        
        newImage[row][column] = newColor            // set the color for the initial pixel
        
        let leftPixel = (row, column - 1)           // left-side pixel of the initial pixel
        let rightPixel = (row, column + 1)          // right-side pixel of the initial pixel
        let upperPixel = (row - 1, column)          // upper-side pixel of the initial pixel
        let lowerPixel = (row + 1, column)          // lower-side pixel of the initial pixel
        
        let fourDimPixels = [leftPixel, rightPixel, upperPixel, lowerPixel]     // pixels in 4 dimentions
        
        for (row,column) in fourDimPixels {                                                     // test each 4 dimentional pixel
            if row >= 0 && row < image.count && column >= 0 && column < image[row].count {      // if 4 dimentional pixel is not out of boundaries
                if image[row][column] == mainPixel {                                            // if 4 dimentional pixel's value is the same as the main pixel's value
                    newImage = fillWithColor(newImage, row, column, newColor)                   // colour it to the new color recursively
                }
            }
        }
        
        return newImage         // return new image
    }
}
