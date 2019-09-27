import MapboxDirections
import MapboxCoreNavigation

/// :nodoc:
@objc public protocol InstructionsCardCollectionDelegate: InstructionsCardContainerViewDelegate {
    /**
     Called when previewing the steps on the current route.
     
     Implementing this method will allow developers to move focus to the maneuver that corresponds to the step currently previewed.
     - parameter instructionsCardCollection: The instructions card collection instance.
     - parameter step: The step for the maneuver instruction in preview.
     */
    @objc(instructionsCardCollection:didPreviewStep:)
    func instructionsCardCollection(_ instructionsCardCollection: InstructionsCardViewController, didPreview step: RouteStep)
    
    /**
     Offers the delegate the opportunity to customize the size of a prototype collection view cell per the associated trait collection.
     
     - parameter instructionsCardCollection: The instructions card collection instance.
     - parameter traitCollection: The traitCollection associated to the current container view controller.
     - returns: The preferred size of the cards for each cell in the instructions card collection.
     */
    @objc(instructionsCardCollection:cardSizeForTraitCollection:)
    optional func instructionsCardCollection(_ instructionsCardCollection: InstructionsCardViewController, cardSizeFor traitCollection: UITraitCollection) -> CGSize
}
