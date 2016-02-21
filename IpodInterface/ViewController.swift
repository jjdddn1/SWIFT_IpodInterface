//
//  ViewController.swift
//  IpodInterface
//
//  Created by Huiyuan Ren on 16/2/20.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleSliderView: UIView!
    
    @IBOutlet weak var digitView: UIView!
    
    var menuViewController : MenuViewController!
    
    
    var feedbackLabel = UILabel(frame: CGRectZero)
    @IBOutlet weak var backGroundView: UIImageView!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var firstDigit: UIImageView!
    
    @IBOutlet weak var secondDigit: UIImageView!
    
    @IBOutlet weak var thirdDigit: UIImageView!
    
    @IBOutlet weak var fourthDigit: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!

    var cleanButtonTouched = true
    var leftButtonTouched = true
    var rightButtonTouched = true
    var menuButtonTouched = true
    
    var result : [Int] = []
    
    var inputMode = true
    var menuMode = false
    
    // total numebr of prime
    var totalNum = 0

    @IBOutlet weak var toBottomDistance: NSLayoutConstraint!
    
    @IBOutlet weak var toTopDistance: NSLayoutConstraint!
    
    @IBOutlet weak var circleWidth: NSLayoutConstraint!
    
    
    // current display value
    var currentValue:CGFloat = 0.0{
        didSet{
            if(currentValue > 9999){
                currentValue = 9999
            }else if currentValue < 0{
                currentValue = 0
            }
            setImage(Int(currentValue))
        }
    }

    // current viewing prime number
    var currentNum:CGFloat = 0.0{
        didSet{
            if(currentNum >= CGFloat(totalNum)){
                currentNum = CGFloat(totalNum - 1)
            }else if currentNum < 0{
                currentNum = 0
            }
            if(totalNum > 0){
                setImage(result[Int(currentNum)])
                countLabel.text = "\(Int(currentNum + 1))/\(totalNum)"
            }else{
                countLabel.text = "0/0"
            }
        }
    }
    
    // diplay the proper image for the number
    func setImage(var value : Int ){
        cleanImage()
        var count = 1
        while(value != 0){
            let digit = value % 10
            let name = "Num\(digit)"
            switch count{
            case 1:
                firstDigit.image = UIImage(named: name)
                break
            case 2:
                secondDigit.image = UIImage(named: name)
                break
            case 3:
                thirdDigit.image = UIImage(named: name)
                break
            case 4:
                fourthDigit.image = UIImage(named: name)
                break
            default:
                break
            }
            count++
            value = value / 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set skin
        if DataStruct.skin == 1 {
            self.backGroundView.image = UIImage(named: "ipodBackground.png")
        }else {
            self.backGroundView.image = UIImage(named: "ipodBackground_2.png")
        }

        countLabel.hidden = true
        
        // special set for different screen resolution
        let a = UIScreen.mainScreen().bounds.height
        if a > 730{
            print("iphone6 plus")
            goButton.layer.cornerRadius = 48
            circleSliderView.layer.cornerRadius = 135
            toBottomDistance.constant = 64
        }else if a > 660 {
            print("iphone6")
            goButton.layer.cornerRadius = goButton.bounds.width / 2
            circleSliderView.layer.cornerRadius = circleSliderView.bounds.width / 2

        }else if a > 560{
            print("iphone5")
            goButton.layer.cornerRadius = 37
            circleSliderView.layer.cornerRadius = 105
            toBottomDistance.constant = 50
        }else{
            goButton.layer.cornerRadius = 31
            circleSliderView.layer.cornerRadius = 176 / 2
            toBottomDistance.constant = 33
            toTopDistance.constant = -25
        }
        
        
        // add a gesturerecognizer for the ipod wheel
        let center : CGPoint = CGPointMake(circleSliderView.bounds.width / 2 , circleSliderView.bounds.height / 2 )
        circleSliderView.addGestureRecognizer(XMCircleGestureRecognizer(midPoint: center, target: self, action: "rotateGesture:", view: circleSliderView as UIView ))
        
        cleanImage()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // reset the display to 0
    func cleanImage(){
        firstDigit.image = UIImage(named: "Num0")
        secondDigit.image = nil
        thirdDigit.image = nil
        fourthDigit.image = nil
    }
    
    // whne user slide the wheel
    func rotateGesture(recognizer:XMCircleGestureRecognizer)
    {
        
        //if user just touch the slider
        if(recognizer.state == .Began){
            cleanButtonTouched = true
            leftButtonTouched = true
            rightButtonTouched = true
            menuButtonTouched = true
        }
        
        cleanButton.highlighted = false
        leftButton.highlighted = false
        rightButton.highlighted = false
        menuButton.highlighted = false
        
        // if rotating
        if let rotation = recognizer.rotation {

            if(menuMode){
                menuViewController.currentSelecton += rotation.degrees / 360 * 5
            }else if (inputMode) {
                currentValue += rotation.degrees / 360 * CGFloat(50 + DataStruct.sensitivity)
            }else{
                currentNum += rotation.degrees / 360 * CGFloat(DataStruct.sensitivity)
            }
        }
        
        // check if the user is tapping any button
        if let currPos = recognizer.currentTouchPostion{
            
            // if user's tapping the clean button
            if(cleanButtonTouched && currPos.x > cleanButton.frame.minX && currPos.x < cleanButton.frame.maxX && currPos.y > cleanButton.frame.minY && currPos.y < cleanButton.frame.maxY){
                cleanButton.highlighted = true
            }else{
                cleanButtonTouched = false
            }
            
            // if user's tapping the left button
            if(leftButtonTouched && currPos.x > leftButton.frame.minX && currPos.x < leftButton.frame.maxX && currPos.y > leftButton.frame.minY && currPos.y < leftButton.frame.maxY){
                leftButton.highlighted = true
            }else{
                leftButtonTouched = false
            }
            
            // if user's tapping the right button
            if(rightButtonTouched && currPos.x > rightButton.frame.minX && currPos.x < rightButton.frame.maxX && currPos.y > rightButton.frame.minY && currPos.y < rightButton.frame.maxY){
                rightButton.highlighted = true
            }else{
                rightButtonTouched = false
            }
            
            // if user's tapping the menu button
            if(menuButtonTouched && currPos.x > menuButton.frame.minX && currPos.x < menuButton.frame.maxX && currPos.y > menuButton.frame.minY && currPos.y < menuButton.frame.maxY){
                menuButton.highlighted = true
            }else{
                menuButtonTouched = false
            }
            
        }
        
        // if touch ended
        if(recognizer.state == .Ended){
            if(cleanButtonTouched){
                cleanUp()
            }else if leftButtonTouched{
                goLeft()
            }else if rightButtonTouched{
                goRight()
            }else if menuButtonTouched{
                goMenu()
            }
            
        }
        
    }
    
    // go button pressed
    @IBAction func goButton(sender: UIButton) {
        if menuMode{
            menuViewController.go()
        }
        else if inputMode{
            let value = Int(currentValue)
            result = brain.calculatePrime(value)
            inputMode = false
            totalNum = result.count
            currentNum = 0
            countLabel.hidden = false
            print(result)
        }
    }
    
    // clean button pressed
    func cleanUp(){
        if menuMode {
            menuMode = false
            digitView.hidden = false
        }else {
            inputMode = true
            currentValue = 0
            countLabel.hidden = true
        }
        
        if( menuViewController != nil){
            menuViewController.view.hidden = true
        }
        print("CleanUp start")
    }
    
    // left button pressed
    func goLeft(){
        if menuMode {
            menuViewController.currentSelecton--
        }else if !inputMode{
            currentNum--
        }
        print("left")
    }
    
    // right button pressed
    func goRight(){
        if menuMode {
            menuViewController.currentSelecton++
        }else if !inputMode{
            currentNum++
        }
        print("right")
    }
    
    // menu button pressed
    func goMenu(){
        if(!menuMode){
            menuMode = true
            if(menuViewController == nil){
                menuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("menu") as! MenuViewController
                
                menuViewController.view.frame = self.digitView.frame
                menuViewController.beforeViewController = self
                self.addChildViewController(self.menuViewController)
                self.view.addSubview(self.menuViewController.view)
                self.menuViewController.didMoveToParentViewController(self)
                
            }else{
                menuViewController.view.hidden = false
                menuViewController.viewDidAppear(true)
            }
            digitView.hidden = true
            
            print("Menu")
        }
    }


}

