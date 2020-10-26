import UIKit
import WebKit

class GaugeDetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var gaugeNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!


    var selectedRun: Reach?

    /*
     Fore now we're just showing the gage name and the image of the gage that can be zoomed
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        if let selectedRun = selectedRun {
            
            if let title = selectedRun.name {
                self.navigationItem.title = title
            }
            
            //let gaugeMetric = selectedRun.gageMetric
            //let gaugeId = selectedRun.gageId
            let reachId = selectedRun.id
            
            //let urlString = "https://www.americanwhitewater.org/content/Gauge2/graph/id/\(gaugeId)/metric/\(gaugeMetric)/.raw"
            let urlString = "https://www.americanwhitewater.org/content/River/view?#/river-detail/\(reachId)/flow"
            print(urlString)
            
            let url = URL(string: urlString)
            webView.load(URLRequest(url: url!))

            gaugeNameLabel.text = selectedRun.gageName
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
        webView.loadHTMLString("<h2 style='text-align: center;'>Unable to load gauge chart</h2>", baseURL: nil)
    }
}
