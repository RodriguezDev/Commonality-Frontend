//
//  SecondViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlets
    @IBOutlet weak var searchBoxOutlet: UITextField!
    @IBOutlet weak var communitiesList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set table variables.
        self.communitiesList.delegate = self
        self.communitiesList.dataSource = self
        self.communitiesList.allowsSelection = false
        
        reloadTopCommunities()
    }
    
    private func reloadTopCommunities() {
        let defaults = UserDefaults.standard
            
        if let email = defaults.string(forKey: defaultsKeys.userEmail), let sessionID = defaults.string(forKey: defaultsKeys.sessionID) {
            let headers: HTTPHeaders = [
                "email": email,
                "sessionID": sessionID
            ]
            
            AF.request(baseUrl + "communities/getTop?offset=0&orderBy=name&ascDesc=ASC", method: .get, headers: headers).responseJSON { response in
                switch (response.result) {
                case .success:
                    if let result = response.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: Table view methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return section == 0 ? "Top Communities" : "My Communities"
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommunityListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "communityListCell", for: indexPath) as! CommunityListTableViewCell
        
        cell.communityTitleLabel.text = "CommunityName"
        cell.colorCircleView.backgroundColor = UIColor.colors[indexPath.row % UIColor.colors.count]
        cell.colorCircleView.layer.cornerRadius = cell.colorCircleView.frame.height / 2
        cell.colorCircleView.alpha = 0.75
        
        return cell
        
    }

}

