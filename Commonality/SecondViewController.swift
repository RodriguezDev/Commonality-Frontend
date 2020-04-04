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
    
    var topCommunities: CommunityResponse?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set table variables.
        self.communitiesList.delegate = self
        self.communitiesList.dataSource = self
        self.communitiesList.allowsSelection = false
        
        self.searchBoxOutlet.setBottomBorder()
        
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
                        self.topCommunities = parseCommunityResponse(JSON: JSON)
                        self.communitiesList.reloadData()
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
        return section == 0 ? "Top communities" : "My communities"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.clear.withAlphaComponent(1)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return topCommunities != nil ? topCommunities!.communities.count : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommunityListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "communityListCell", for: indexPath) as! CommunityListTableViewCell
        
        var communities: [Community]!
        
        if (indexPath.section == 0 && topCommunities != nil) {
            communities = topCommunities!.communities
        }
        
        cell.communityTitleLabel.text = communities[indexPath.row].name
        cell.colorCircleView.backgroundColor = UIColor.colors[indexPath.row % UIColor.colors.count]
        cell.colorCircleView.layer.cornerRadius = cell.colorCircleView.frame.height / 2
        cell.colorCircleView.alpha = 0.75
        
        return cell
        
    }

}

