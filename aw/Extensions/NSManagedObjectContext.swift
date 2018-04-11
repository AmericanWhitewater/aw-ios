import CoreData
import Foundation

extension NSManagedObjectContext {
    func persist(block: @escaping () -> Void) {
        perform {
            block()

            do {
                try self.save()
            } catch let nserror as NSError {
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                self.rollback()
            }
        }
    }
}
