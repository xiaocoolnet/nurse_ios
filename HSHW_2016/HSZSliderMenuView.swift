//
//  SliderMenuView.swift
//  SwiftSliderMenu
//

import UIKit


protocol SliderMenuViewDelegate :NSObjectProtocol{
    func sliderMenuClickIndex(index: NSInteger)
}

class HSZSliderMenuView: UIView {
    var scrollView:UIScrollView
//    var directButton:UIButton
    var menuButtonArray:NSMutableArray
    var delegate: SliderMenuViewDelegate?
    var hasBtn:Bool = true
    var lineView = UIView()
    let directView = UIView()
    var selectIndex:Int?
//    let newView = NSBundle.mainBundle().loadNibNamed("HSComOpenHeader", owner: nil, options: nil).first as! HSComOpenHeader
    var selectButton:UIButton
        {
        willSet(newButton) {
            
            let windown: UIWindow = UIApplication.sharedApplication().keyWindow!
            var originX = CGFloat(newButton.center.x) - CGRectGetMidX(windown.frame)
            let maxOrigin = CGFloat(self.scrollView.contentSize.width) - CGRectGetWidth(windown.frame)

            if (originX < 0) {
                originX = CGFloat(0)
            }else if (originX > maxOrigin) {
                originX = maxOrigin + CGRectGetWidth(newButton.frame) + 10
            }
            
            self.scrollView.setContentOffset(CGPointMake(originX, 0), animated: true)
            
            if (newButton == selectButton) {
                return;
            }
            self.scrollView.bringSubviewToFront(lineView)
            UIView.animateWithDuration(1.0) {
                self.lineView.frame = CGRectMake(newButton.frame.minX, self.scrollView.frame.height - 2, newButton.frame.width, 2)
            }
            selectButton.setTitleColor(UIColor(red: 104/255.5, green: 104/255.5, blue: 124/255.5, alpha: 1.0), forState: UIControlState.Normal);
            newButton.setTitleColor(UIColor(red: 152/255.5, green: 0/255.5, blue: 112/255.5, alpha: 1.0), forState: UIControlState.Normal);

            let animation1 : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            animation1.fromValue = NSNumber(float: 1.0)
            animation1.toValue  = NSNumber(float: 1.1)
            animation1.duration = 0.3;
            animation1.repeatCount = 1
            animation1.fillMode = kCAFillModeForwards
            animation1.removedOnCompletion = false;
            animation1.autoreverses = false;
            newButton.titleLabel?.layer.addAnimation(animation1, forKey: "animation1")
            
            let animation2 : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            animation2.fromValue = NSNumber(float: 1.1)
            animation2.toValue  = NSNumber(float: 1.0)
            animation2.duration = 0.3;
            animation2.repeatCount = 1
            animation2.fillMode = kCAFillModeForwards
            animation2.removedOnCompletion = false;
            animation2.autoreverses = false;
            selectButton.titleLabel?.layer.addAnimation(animation2, forKey: "animation2")
            
        }
    }
    
    var menuNameArray:NSMutableArray{
        
        willSet (newMenuNameArray) {
            self.addMenuButton(newMenuNameArray);
        }
        didSet {
            
        }
    }
    
    
    override init(frame: CGRect) {
    scrollView = UIScrollView.init()
    menuButtonArray = NSMutableArray()
    menuNameArray = NSMutableArray()
    selectButton = UIButton()
    
    super.init(frame: frame)

    }
    override func layoutSubviews() {
        if hasBtn {
            self.setViews()
        }else{
            setViewsWithNoButton()
        }
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    
 private func setViews() {
    
    scrollView.frame = CGRect(x: 0, y: 0, width:frame.width, height: frame.height)
    scrollView.backgroundColor = UIColor.clearColor();
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.showsVerticalScrollIndicator = false;
    
    self.addSubview(scrollView)
    scrollView.addSubview(lineView)
    self.addSubview(directView);
    }
    
    func setViewsWithNoButton() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CGRectGetHeight(self.frame))
        scrollView.backgroundColor = UIColor.clearColor();
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        self.addSubview(scrollView)
    }
    func addMenuButton(muneNameArray:NSMutableArray) {
       self.menuButtonArray.enumerateObjectsUsingBlock { (AnyObject, Int, UnsafeMutablePointer) -> Void in
            AnyObject.removeFromSuperview()
        }
        self.menuButtonArray.removeAllObjects();

        for index in 0 ..< muneNameArray.count {
            let button = UIButton(type: UIButtonType.Custom);
            let titleString:String = muneNameArray[index] as! String;
            button.setTitle(titleString, forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(15)
            button.titleLabel?.text = titleString;
            button.setTitleColor(UIColor(red: 104/255.5, green: 104/255.5, blue: 104/255.5, alpha: 1.0), forState: UIControlState.Normal);
            button .addTarget(self, action: #selector(HSZSliderMenuView.muneItemClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = index;
            var originX = CGFloat(15);
            if  self.menuButtonArray.count != 0 {
               let button:UIButton = self.menuButtonArray.lastObject as! UIButton;
                originX = CGRectGetMaxX(button.frame) + CGFloat(15.0);
            }
            
            let attributes = [NSFontAttributeName: button.titleLabel!.font]

            let size = titleString.boundingRectWithSize(CGSizeMake(200,CGRectGetHeight(self.frame)), options:NSStringDrawingOptions.UsesFontLeading, attributes: attributes, context: nil)
            
            button.frame = CGRect(x: originX, y: 0, width: size.width, height: CGRectGetHeight(self.frame))
            
            scrollView .addSubview(button)
            menuButtonArray .addObject(button);
        }
        
        let button:UIButton = self.menuButtonArray.lastObject as! UIButton;
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), CGRectGetHeight(self.scrollView.frame));
    }
    
    func muneItemClick(button:UIButton) {
        selectButton = button;
        selectIndex = button.tag
        self.delegate?.sliderMenuClickIndex(button.tag)
        
    }

    
    func makeHeaderOpenView() {
        
    }
    
    func setSelectTilteIndex(index:NSInteger) {
        let button = self.menuButtonArray[index]
        selectIndex = index
        self.selectButton = button as! UIButton;
    }
    
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
