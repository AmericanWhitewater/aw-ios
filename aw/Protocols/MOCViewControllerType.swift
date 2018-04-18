import CoreData
import Foundation
import UIKit

protocol MOCViewControllerType {
    var managedObjectContext: NSManagedObjectContext? { get set }
}

extension MOCViewControllerType {
    func injectContextAndContainerToChildVC(segue: UIStoryboardSegue) {
        guard var destinationVC = segue.destination as? MOCViewControllerType else { return }

        destinationVC.managedObjectContext = managedObjectContext
    }

    func injectContextAndContainerToNavChildVC(segue: UIStoryboardSegue) {
        guard let navVC = segue.destination as? UINavigationController,
            var destinationVC = navVC.viewControllers[0] as? MOCViewControllerType else { return }

        destinationVC.managedObjectContext = managedObjectContext
    }
}
