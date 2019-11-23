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
    
    static let tableViewCellHeight: CGFloat = screenHeight * (6 / 28)
    static let headerViewHeight: CGFloat = tableViewCellHeight / 6
    
    static let collectionViewCellSize: CGSize = CGSize(
        width: (screenWidth - left - right - (itemsPerRow - 1) * minLineSpacing) / itemsPerRow,
        height: tableViewCellHeight - top - bottom - 1)
    
    static let cornerRadius = tableViewCellHeight / 16
}

