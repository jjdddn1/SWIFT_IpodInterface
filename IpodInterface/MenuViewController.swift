//
//  MenuViewController.swift
//  IpodInterface
//
//  Created by Huiyuan Ren on 16/2/21.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import MessageUI


class MenuViewController: UIViewController , MFMailComposeViewControllerDelegate{

    var beforeViewController : ViewController?
    
    @IBOutlet weak var sensitivityLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var rateInAppStoreLabel: UILabel!
    
    @IBOutlet weak var exitLabel: UILabel!
    
    var labelArray : [UILabel] = []
    
    var currentSelecton : CGFloat = 0.0{
        didSet{
            if(currentSelecton > 4){
                currentSelecton = 4
            }else if currentSelecton < 0{
                currentSelecton = 0
            }
            
            setBorder(Int(currentSelecton))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sensitivityLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        feedbackLabel.layer.borderColor = UIColor.whiteColor().CGColor
        shareLabel.layer.borderColor = UIColor.whiteColor().CGColor
        rateInAppStoreLabel.layer.borderColor = UIColor.whiteColor().CGColor
        exitLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        labelArray.append(sensitivityLabel)
        labelArray.append(feedbackLabel)
        labelArray.append(shareLabel)
        labelArray.append(rateInAppStoreLabel)
        labelArray.append(exitLabel)

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        currentSelecton = 0
        switch DataStruct.sensitivity{
        case 10:
            sensitivityLabel.text = " Sensitivity : Low "
            break
        case 30:
            sensitivityLabel.text = " Sensitivity : Medium "
            break
        case 50:
            sensitivityLabel.text = " Sensitivity : High "
            break
        default:
            break
        }
    }
    
    func setBorder(num : Int){
        for var i = 0; i < labelArray.count; i++ {
            let label = labelArray[i]
            label.layer.borderWidth = 0
        }
        let label = labelArray[num]
        label.layer.borderWidth = 3
    }
    
    func go(){
        switch Int(currentSelecton){
        case 0:
            if(DataStruct.sensitivity == 50){
                DataStruct.sensitivity = 10
                sensitivityLabel.text = " Sensitivity : Low "
            }else if(DataStruct.sensitivity == 30){
                DataStruct.sensitivity = 50
                sensitivityLabel.text = " Sensitivity : High "
            }else {
                DataStruct.sensitivity = 30
                sensitivityLabel.text = " Sensitivity : Medium "
            }
            break
        case 1:
            if DataStruct.skin == 1 {
                beforeViewController!.backGroundView.image = UIImage(named: "ipodBackground_2.png")
                 DataStruct.skin = 2
            }else {
                beforeViewController!.backGroundView.image = UIImage(named: "ipodBackground.png")
                 DataStruct.skin = 1
            }
            break
        case 2:
            sendFeedBack()
            break
        case 3:
            if let requestUrl = NSURL(string: "https://itunes.apple.com/us/app/calculator-calculator-that/id1081975220?l=zh&ls=1&mt=8") {
                UIApplication.sharedApplication().openURL(requestUrl)
            }
            break
        case 4:
            self.view.hidden = true
            beforeViewController?.menuMode = false
            beforeViewController?.digitView.hidden = false
            break
        default:
            break
        }
    }
    
    func sendFeedBack(){
        let Subject = "Feedback for Find Prime"
        let toRecipients = ["huiyuanr@usc.edu"]
        let mc : MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(Subject)
        mc.setToRecipients(toRecipients)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mc, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }

    }
    
    func showSendMailErrorAlert() {
            let alert = UIAlertController(title: "Could Not Send Email", message: "Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            NSLog("Mail Cancelled")
        case MFMailComposeResultFailed.rawValue:
            NSLog("Mail sent failure: %@",[error!.localizedDescription])
        case MFMailComposeResultSaved.rawValue:
            NSLog("Mail Saved")
        case MFMailComposeResultSent.rawValue:
            NSLog("Mail Sent")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
