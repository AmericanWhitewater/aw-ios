import UIKit

extension UITableView {

    // tableView headerViews change height on when set,
    // so we need to reset it to force autolayout changes when
    // the contents heights change
    func layoutTableHeaderView() {

        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutFormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])

        headerView.addConstraints(temporaryWidthConstraints)

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let headerSize = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame

        frame.size.height = height
        headerView.frame = frame

        self.tableHeaderView = headerView

        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true

    }
}
