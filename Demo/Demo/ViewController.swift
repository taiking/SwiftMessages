//
//  ViewController.swift
//  Demo
//
//  Created by Tim Moose on 8/11/16.
//  Copyright © 2016 SwiftKick Mobile. All rights reserved.
//

import UIKit
import SwiftMessages

class ViewController: UITableViewController {

    var items: [Item] = [
        .titleBody(title: "ANY VIEW", body: "Any view, no matter how cute, can be displayed as a message.", function: ViewController.demoAnyView),
    ]

    /*
     MARK: - UITableViewDataSource
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[(indexPath as NSIndexPath).row]
        return item.dequeueCell(tableView)
    }
    
    /*
     MARK: - UITableViewDelegate
     */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[(indexPath as NSIndexPath).row]
        item.performDemo()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /*
     MARK: - Demos
     */
    
    static func demoAnyView() -> Void {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puppies")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let messageView = BaseView(frame: .zero)
        messageView.layoutMargins = .zero
        messageView.preferredHeight = 220.0
        if #available(iOS 11, *) {
            // Switch to a card-style layout for iOS 11 because the image
            // doesn't fit well behind the notch. Need to install a background
            // view for the drop shadow.
            let backgroundView = UIView()
            backgroundView.layer.cornerRadius = 100
            imageView.layer.cornerRadius = 100
            messageView.installBackgroundView(backgroundView)
            messageView.installContentView(imageView, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            messageView.safeAreaTopOffset = -6
        } else {
            messageView.installContentView(imageView)
        }
        messageView.dismissMoveQuantity = 100
        messageView.configureDropShadow()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        config.presentationStyle = .center
        config.isAutoHide = false
        SwiftMessages.show(config: config, view: messageView)
    }
}

typealias Function = () -> Void

enum Item {
    
    case titleBody(title: String, body: String, function: Function)
    case explore
    case counted

    func dequeueCell(_ tableView: UITableView) -> UITableViewCell {
        switch self {
        case .titleBody(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleBody") as! TitleBodyCell
            cell.titleLabel.text = data.title
            cell.bodyLabel.text = data.body
            cell.configureBodyTextStyle()
            return cell
        case .explore:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Explore") as! TitleBodyCell
            cell.configureBodyTextStyle()
            return cell
        case .counted:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Counted") as! TitleBodyCell
            cell.configureBodyTextStyle()
            cell.bodyLabel.configureCodeStyle(on: "show()")
            cell.bodyLabel.configureCodeStyle(on: "hideCounted(id:)")
            return cell
        }
    }
    
    func performDemo() {
        switch self {
        case .titleBody(let data):
            data.function()
        default:
            break
        }
    }
}

class TitleBodyCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    func configureBodyTextStyle() {
        let bodyStyle = NSMutableParagraphStyle()
        bodyStyle.lineSpacing = 5.0
        bodyLabel.configureBodyTextStyle()
    }
}
