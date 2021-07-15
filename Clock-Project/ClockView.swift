//
//  ClockView.swift
//  Clock-Project
//
//  Created by Murtaza Mehmood on 16/07/2021.
//

import UIKit

class ClockView: UIView{
    
    //MARK
    var hourMarkLayer: CAShapeLayer!
    var minuteMarkLayer: CAShapeLayer!
    
    //HANDS
    var secondHandLayer: CAShapeLayer!
    var minuteHandLayer: CAShapeLayer!
    var hourHandLayer: CAShapeLayer!
    var needleCenterLayer: CAShapeLayer!
    
    //DATE
    var dateWindowShapeLayer: CAShapeLayer!
    var dateTextLayer: CATextLayer!
    
    private let minuteHandWidth: CGFloat = 1
    private let hourHandWidth: CGFloat = 2
    
    private var scalingFactor: CGFloat {
        (frame.size.height / frame.size.width)
    }
    
    private var needleCenterWidth: CGFloat {
        (frame.size.width * 0.05) * scalingFactor
    }
    
    //HANDS WITH AND HEIGHT
    private var secondsHandWidth: CGFloat{
        0.75 * scalingFactor
    }
    
    private var secondsHandHeight: CGFloat{
        (frame.size.height / 2)
    }
    
    private var minuteHandsWidth: CGFloat {
        2 * scalingFactor
    }
    
    private var minuteHandsHeight: CGFloat {
        (frame.size.height / 2) * scalingFactor
    }
    
    private var hourHandsWidth: CGFloat {
        2 * scalingFactor
    }
    
    private var hourHandsHeight: CGFloat {
        ((frame.size.height / 2) * 0.7) * scalingFactor
    }
    
    private var weeks: [String] = ["Sat",
                                   "Sun",
                                   "Mon",
                                   "Tue",
                                   "Wed",
                                   "Thu",
                                   "Fri"]
    
    var second: Int = 0
    var minute: Int = 0
    var hours: Int = 0
    
    private var renderTimes: Int = 0
    
    //TIMER
    var timer: Timer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    
    
    func commonInit(){
        hourMarkLayer = CAShapeLayer()
        minuteMarkLayer = CAShapeLayer()
        
        secondHandLayer = CAShapeLayer()
        minuteHandLayer = CAShapeLayer()
        hourHandLayer = CAShapeLayer()
        needleCenterLayer = CAShapeLayer()
        
        dateWindowShapeLayer = CAShapeLayer()
        dateTextLayer = CATextLayer()
        
        timer = Timer()
    }
    
    fileprivate func setupLayers(){
        guard self.renderTimes < 1 else{return}
        self.renderTimes += 1
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
        layer.borderWidth = 0.75
        
        //CIRCUMFERENCE OF CLOCKVIEW
        let circumferenceOfView = 2 * .pi * self.frame.size.width / 2
        let segmentMinutes = circumferenceOfView / 60
        let segmentsHours = circumferenceOfView / 12
        let hourHandSpace = segmentsHours - hourHandWidth
        let minuteHandSpace = segmentMinutes - minuteHandWidth
        
        //HOUR MARK
        hourMarkLayer.fillColor = UIColor.clear.cgColor
        hourMarkLayer.strokeColor = UIColor.black.cgColor
        hourMarkLayer.lineWidth = 15.0
        hourMarkLayer.lineDashPattern = [hourHandWidth as NSNumber,hourHandSpace as NSNumber]
        hourMarkLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.size.height)).cgPath
        hourMarkLayer.frame = bounds
        hourMarkLayer.transform = CATransform3DMakeRotation(0.505, 0, 0, 1)
        
        //MINUTE MARK
        minuteMarkLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.size.height)
        minuteMarkLayer.fillColor = UIColor.clear.cgColor
        minuteMarkLayer.strokeColor = UIColor.black.cgColor
        minuteMarkLayer.lineWidth = 8.0
        minuteMarkLayer.lineDashPattern = [minuteHandWidth as NSNumber,minuteHandSpace as NSNumber]
        minuteMarkLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.size.height)).cgPath
        minuteMarkLayer.transform = CATransform3DMakeRotation(0.505, 0, 0, 1)
        
        //CENTER OF HANDS
        needleCenterLayer.fillColor = UIColor.black.cgColor
        needleCenterLayer.strokeColor = UIColor.black.cgColor
        needleCenterLayer.path = UIBezierPath(ovalIn: CGRect(x: (frame.width / 2) - (needleCenterWidth / 2), y: (frame.height / 2) - (needleCenterWidth / 2), width: needleCenterWidth, height: needleCenterWidth)).cgPath
        
        
        //SECONDS HAND
        secondHandLayer.fillColor = UIColor.red.cgColor
        secondHandLayer.strokeColor = UIColor.red.cgColor
        secondHandLayer.path = UIBezierPath(rect: CGRect(x: (frame.size.width / 2) - (secondsHandWidth/2), y: (frame.size.height / 2) - secondsHandHeight, width: secondsHandWidth, height: secondsHandHeight)).cgPath
        secondHandLayer.frame = bounds
        
        //MINUTES HAND
        minuteHandLayer.fillColor = UIColor.black.cgColor
        minuteHandLayer.strokeColor = UIColor.black.cgColor
        minuteHandLayer.path = UIBezierPath(rect: CGRect(x: (frame.size.width / 2) - (minuteHandsWidth/2), y: 0, width: minuteHandsWidth, height: minuteHandsHeight)).cgPath
        minuteHandLayer.frame = bounds
        
        //HOUR HAND
        hourHandLayer.fillColor = UIColor.black.cgColor
        hourHandLayer.strokeColor = UIColor.black.cgColor
        hourHandLayer.frame = bounds
        hourHandLayer.path = UIBezierPath(rect: CGRect(x: frame.size.width / 2 - (hourHandWidth / 2),
                                                      y: (frame.size.height / 2) - (hourHandsHeight),
                                                      width: hourHandWidth,
                                                      height: hourHandsHeight)).cgPath
        
        
        
        
        layer.insertSublayer(needleCenterLayer, at: 0)
        
        layer.insertSublayer(secondHandLayer, at: 0)
        layer.insertSublayer(minuteHandLayer, at: 0)
        layer.insertSublayer(hourHandLayer, at: 0)
        
        layer.insertSublayer(hourMarkLayer, at: 0)
        layer.insertSublayer(minuteMarkLayer, at: 0)
        dateView()
        startClock()
    }
    
    //MAKE DATE WINDOW
    fileprivate func dateView(){
        let date = getCurrentTimeAndDate()
        
        let currentDate = "\(weeks[date.4]) \(date.3)"
        
        let sizeOfString = sizeOfDateString(nsString: currentDate as NSString)
        
        dateTextLayer.frame = CGRect(x: 3, y:1.5, width: sizeOfString.width, height: sizeOfString.height)
        dateTextLayer.font = CTFontCreateWithName("Helvetica" as CFString, 11, nil)
        dateTextLayer.fontSize = 11
        dateTextLayer.contentsScale = UIScreen.main.scale
        dateTextLayer.string = currentDate
        dateTextLayer.foregroundColor = UIColor.black.cgColor
        dateTextLayer.isWrapped = true
        dateTextLayer.alignmentMode = .center
        dateTextLayer.truncationMode = .middle

        dateWindowShapeLayer.fillColor = UIColor.clear.cgColor
        dateWindowShapeLayer.borderWidth = 0.75
        dateWindowShapeLayer.borderColor = UIColor.black.cgColor
        dateWindowShapeLayer.cornerRadius = 3
        dateWindowShapeLayer.frame = CGRect(x: (frame.size.width - 15) - (sizeOfString.width + 6),
                                            y: (frame.size.height / 2) - ((sizeOfString.height + 3) / 2),
                                            width: sizeOfString.width + 6,
                                            height: sizeOfString.height + 3)
        dateWindowShapeLayer.path = UIBezierPath(rect: CGRect(x: (frame.size.width - 15) - (sizeOfString.width + 6),
                                                              y: frame.size.height / 2,
                                                              width: sizeOfString.width + 6,
                                                              height: sizeOfString.height + 3)).cgPath
        dateWindowShapeLayer.addSublayer(dateTextLayer)
        layer.insertSublayer(dateWindowShapeLayer, at: 0)

    }
    
    //GET SIZE OF DATE STRING IN CGSIZE
    fileprivate func sizeOfDateString(nsString: NSString) -> CGSize {
        
        let size = nsString.size(withAttributes: [.font : UIFont(name: "Helvetica", size: 11)!])
        return nsString.boundingRect(with: CGSize(width: size.width, height: 11),
                              options: .usesLineFragmentOrigin,
                              attributes: [.font : UIFont(name: "Helvetica", size: 11)!],
                              context: nil).size
    }
    
    
    //GET CURRENT DATE
    fileprivate func getCurrentTimeAndDate() ->(Int, Int, Int, Int, Int){
        let date = Date()

        // *** create calendar object ***
        let calendar = Calendar.current

        // *** Get components using current Local & Timezone ***
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))

        // *** Get Individual components from date ***
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let day = calendar.component(.day, from: date)
        let weekOfDay = calendar.component(.weekday, from: date)
        return (hour,minutes,seconds,day,weekOfDay)
    }
    
    //TIMER FOR CLOCK
    fileprivate func clockTimer(){
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            let time = self.getCurrentTimeAndDate()
            
            self.hours = time.0
            self.minute = time.1
            self.second = time.2
            let currentDate = "\(self.weeks[time.4]) \(time.3)"
            
            self.dateTextLayer.string = currentDate
            self.secondHandLayer.transform =  CATransform3DMakeRotation((CGFloat((Double.pi * 2)) / 60) * CGFloat(self.second), 0, 0, 1)
            self.minuteHandLayer.transform = CATransform3DMakeRotation(((2 * .pi) / 60) * CGFloat(self.minute), 0, 0, 1)
            self.hourHandLayer.transform = CATransform3DMakeRotation(((2 * .pi) / 12) * CGFloat(self.hours), 0, 0, 1)
        }
    }
    
    //MARK:- START CLOCK
    func startClock(){
        clockTimer()
    }
    
}
