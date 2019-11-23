import UIKit

struct InventoryConstants {
    
    private static let screenHeight = UIScreen.main.bounds.height
    private static let screenWidth = UIScreen.main.bounds.width
    
    private static let itemsPerRow: CGFloat = 2.5
    
    static let top: CGFloat = 10
    static let bottom: CGFloat = 10
    static let left: CGFloat = 10
    static let right: CGFloat = 10
    
    static let minLineSpacing: CGFloat = screenWidth / 40
    
    static let tableViewCellHeight: CGFloat = screenHeight / 4
    static let collectionViewCellSize: CGSize = CGSize(
        width: (screenWidth - left - right - (itemsPerRow - 1) * minLineSpacing) / itemsPerRow,
        height: tableViewCellHeight - top - bottom)
    
    static let cornerRadius = tableViewCellHeight / 16
}

