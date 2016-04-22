import WebKit

class WebViewController: UIViewController {
  var webView: WKWebView!
  
  override func loadView() {
    webView = WKWebView()
    view = webView
  }
  
  override func viewDidLoad() {
    guard let url = NSURL(string: "https://www.bignerdranch.com") else {
      return
    }
    
    let urlRequest = NSURLRequest(URL: url)
    webView.loadRequest(urlRequest)
  }
}
