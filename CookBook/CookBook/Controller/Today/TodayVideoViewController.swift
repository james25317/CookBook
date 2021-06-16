//
//  TodayVideoViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/30.
//

import UIKit
import WebKit

class TodayVideoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var viewModel: TodayViewModel?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        loadWebView()
    }

    private func loadWebView() {

        guard let viewModel = viewModel,
            let value = viewModel.todayRecipeViewModel.value else { return }

        let videoId = value.videoId

        guard let url = URL(
            string: "https://www.youtube.com/embed/" + String(describing: videoId)
        ) else { return }
        
        webView.load(URLRequest(url: url))

        webView.allowsBackForwardNavigationGestures = true
    }
}
