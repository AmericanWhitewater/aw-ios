import UIKit

class GageViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var graphImage: UIImageView!

    var sourceReach: Reach?
    var gageDetail: AWGageResponse? {
        didSet {
            draw()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let reach = sourceReach,
            reach.gageId != 0, reach.gageMetric != 0,
            let url = URL(string:
                "https://www.americanwhitewater.org/content/Gauge2/graph/id/\(reach.gageId)/metric/\(reach.gageMetric)/.raw")
            else { return }
        AWApiHelper.fetchGageDetail(gageId: Int(reach.gageId)) { gageResponse in
            DispatchQueue.main.async {
                self.gageDetail = gageResponse
            }
        }
        if let imageData = try? Data(contentsOf: url) {
            graphImage.image = UIImage(data: imageData)
        }
    }
}

extension GageViewController {
    func draw() {
        guard let gageDetail = gageDetail,
            let reach = sourceReach,
            let condition = gageDetail.conditions.filter({ $0.series == reach.gageMetric }).first
            else { return }

        print(gageDetail.conditions)
        print(condition)
        let metric = gageDetail.metrics[Int(reach.gageMetric)]
        nameLabel.text = gageDetail.gage.name
        readingLabel.text = condition.reading
        unitsLabel.text = metric?.unit
    }
}
