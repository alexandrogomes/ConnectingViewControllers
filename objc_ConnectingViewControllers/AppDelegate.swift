//
//  AppDelegate.swift
//  objc_ConnectingViewControllers
//
//  Created by alexandro on 8/30/16.
//  Copyright © 2016 Gazeus. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var app: App?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let window = window {
            app = App(window: window)

        }
        
        return true
    }
}

struct Episode {
    var title: String
}

final class ProfileViewController: UIViewController {
    var person: String = ""
    var didTapClose: () -> () = {}
}

final class DetailViewController: UIViewController {
    @IBOutlet weak var label: UILabel? {
        didSet {
            label?.text = episode?.title
        }
    }
    var episode: Episode?
}

final class EpisodesViewController: UITableViewController {
    
    var didTapProfile: () -> () = {}
    
    @IBAction func actionProfile(sender: AnyObject) {
        didTapProfile()
    }
    
    let episodes = [Episode(title:"Episode One"), Episode(title:"Episode Two"), Episode(title:"Episode Three")]
    var didSelect: (Episode) -> () = { _ in }
    override func viewDidLoad() {
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"Cell")
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let episode = episodes[indexPath.row]
        didSelect(episode)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.title
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DetailViewController {
            vc.episode = episodes[tableView.indexPathForSelectedRow!.row]
        } else if let nc = segue.destinationViewController as? UINavigationController, pvc = nc.viewControllers.first as? ProfileViewController {
            pvc.person = "My Name"
        } else {
            fatalError()
        }
    }
    
    @IBAction func unwindToHere(segue:UIStoryboardSegue) {
        
    }
}

final class App {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController : UINavigationController
    
    init(window: UIWindow) {
        navigationController = window.rootViewController as! UINavigationController
        let episodeVC = navigationController.viewControllers[0] as! EpisodesViewController
        episodeVC.didSelect = showEpisode
        episodeVC.didTapProfile = showProfile
    }
    
    func showEpisode(episode: Episode) {
        let detailVC = storyboard.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailVC.episode = episode
        self.navigationController.pushViewController(detailVC, animated: true)
    }
    
    func showProfile() {
        let profileNC = self.storyboard.instantiateViewControllerWithIdentifier("Profile") as! UINavigationController
        let profileVC = profileNC.viewControllers[0] as! ProfileViewController
        profileVC.didTapClose = {
            
        }
        self.navigationController.presentViewController(profileVC, animated: true, completion: nil)
    }
}