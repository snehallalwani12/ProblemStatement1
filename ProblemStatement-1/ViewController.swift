//
//  ViewController.swift
//  ProblemStatement-1
//
//  Created by snehal_lalwani on 20/07/18.
//  Copyright © 2018 snehal_lalwani. All rights reserved.
//

import UIKit

class AppTableViewCell : UITableViewCell
{
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appKindLabel: UILabel!
    @IBOutlet weak var appImageLabel: UIImageView!
    @IBOutlet weak var abackgroundView: UIView!
}

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var appTableView: UITableView!
    
    var appArray : NSMutableArray = NSMutableArray()
    var spinner : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.appTableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(spinner)
        spinner.center = self.view.center
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        self.appTableView.isHidden = true
        self.errorLabel.isHidden = true
        
        spinner.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.AppDataNotification(_:)), name:NSNotification.Name(rawValue: APP_LIST_API_NOTIFICATION), object: nil)
        AppListAPI().getAppData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.customizeNavigationBar()
    }
    
    func customizeNavigationBar()
    {
        let leftItem = UIBarButtonItem(title: "Top Applications", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        leftItem.isEnabled = false
        leftItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func AppDataNotification(_ notification: Notification)
    {
        spinner.stopAnimating()
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: APP_LIST_API_NOTIFICATION), object:nil)
        
        if (notification.object is String)
        {
            self.errorLabel.text = notification.object as? String
            self.errorLabel.isHidden = false
            self.appTableView.isHidden = true
        }
        else
        {
            appArray = DataManager.sharedInstance.makeDataModel(notification.object as! NSDictionary)
            if appArray.count != 0
            {
                self.appTableView.reloadData()
                self.errorLabel.isHidden = true
                appTableView.isHidden = false
            }
            else
            {
                self.errorLabel.text = SERVER_ERROR_MESSAGE
                self.errorLabel.isHidden = false
                self.appTableView.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return appArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppTableViewCell", for: indexPath) as! AppTableViewCell
        
        let appObj : AppObject = appArray.object(at: indexPath.row) as! AppObject
        cell.appNameLabel.text = appObj.artistName
        cell.appKindLabel.text = appObj.kind
        
        let imageUrl:URL = URL(string: appObj.artworkUrl100)!
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                cell.appImageLabel.image = image
            }
        }

        cell.abackgroundView.layer.cornerRadius = 7.0
        cell.abackgroundView.layer.shadowColor = UIColor.black.cgColor
        cell.abackgroundView.layer.shadowRadius = 3
        cell.abackgroundView.layer.shadowOpacity = 1.0
        cell.abackgroundView.clipsToBounds = true
        
        cell.selectionStyle = .none
        return cell
    }


}

