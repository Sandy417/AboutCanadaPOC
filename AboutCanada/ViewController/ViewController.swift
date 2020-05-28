//
//  ViewController.swift
//  AboutCanada
//
//  Created by Sandeep on 19/05/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import UIKit
import SystemConfiguration

var contentTableView: UITableView!
let cellId = Constants.kcellId
var contents : [Content]  = [Content]()
var activityIndicatorView = UIActivityIndicatorView()
var navigationItem = UINavigationItem()
let imageCache = NSCache<AnyObject, UIImage>()
var navigationBar = UINavigationBar()
var contentsViewModel = ContentViewModel()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ContentTableViewCell {
        cell.setContentImage(image: UIImage(named:Constants.kdefaultImage1)!)
        cell.stopAnimating()
        let currentLastItem = contentsViewModel.contents[indexPath.row]//contents[indexPath.row]
        cell.content = currentLastItem
        if let cacheImage = imageCache.object(forKey: currentLastItem.title as AnyObject) {
            cell.setContentImage(image: cacheImage)
        } else {
            
            if let url:URL = URL(string: currentLastItem.imageHref) {
                cell.startAnimating()
URLSession.shared.downloadTask(with: url, completionHandler: { (_, _, _) -> Void in
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let img:UIImage! = UIImage(data: data)
                            cell.setContentImage(image: img)
                            imageCache.setObject(img, forKey: currentLastItem.title as AnyObject)
                            cell.stopAnimating()
                        })
                    } else {
                        cell.setContentImage(image: UIImage(named:Constants.kdefaultImage1)!)
                        cell.stopAnimating()
                        
                    }
                }).resume()
            } else {
                cell.setContentImage(image: UIImage(named:Constants.kdefaultImage1)!)
                cell.stopAnimating()
                
            }
        }
        return cell
    }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsViewModel.contents.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let cell = ContentTableViewCell()
        cell.setupConstraints()
    }
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
            if let windowScene = windowScene as? UIWindowScene {
                statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            }
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    func showActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        
    }
    
    @objc func refreshButtonClicked(_ sender: UIBarButtonItem) {
        ReachabilityCheckManager.isReachable { _ in
            self.showActivityIndicator()
            self.fetchContents()
        }
        ReachabilityCheckManager.isUnreachable { _ in
            self.showOfflineAlert()
        }
    }
    func setupNavigationBar() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height:44))
        navigationBar.backgroundColor = UIColor.white
        let rightButton = UIBarButtonItem(title: Constants.krefresh, style: .plain, target: self, action: #selector(ViewController.refreshButtonClicked(_:)))
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .purple
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().barTintColor = .purple
            UINavigationBar.appearance().isTranslucent = false
        }
        
        navigationItem.rightBarButtonItem = rightButton
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
        
        var statusBarHeight: CGFloat = 0
        if !(self.prefersStatusBarHidden) {
        statusBarHeight = getStatusBarHeight()
        }
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    func setupTableView() {
        contentTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        contentTableView.separatorColor = UIColor.gray
        contentTableView.dataSource = self
        contentTableView.delegate = self
        contentTableView.rowHeight = UITableView.automaticDimension
        contentTableView.estimatedRowHeight = 100
        self.view.addSubview(contentTableView)
        
        contentTableView.register(ContentTableViewCell.self, forCellReuseIdentifier: cellId)
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    func showOfflineAlert() {
        let alertController = UIAlertController(title: "", message: Constants.kInternetUnavailableMsg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.kOk, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
        setupTableView()
        ReachabilityCheckManager.isReachable { _ in
            self.showActivityIndicator()
            self.fetchContents()
        }
        ReachabilityCheckManager.isUnreachable { _ in
            self.showOfflineAlert()
        }
    }
    func fetchContents () {
        contentsViewModel.fetchContents { (_, title, _) in
            
            DispatchQueue.main.async {
                self.navigationItem.title = contentsViewModel.title as String
                contentTableView.reloadData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func asciiToDictionary(text: String) -> [String: Any]? {
        if let encodedData = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any]
            } catch {
            }
        }
        return nil
    }
    
}
