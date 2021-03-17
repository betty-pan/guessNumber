//
//  ViewController.swift
//  guessNumber
//
//  Created by Betty Pan on 2021/3/17.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var chanceImages: [UIImageView]!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet var numberTrackerLabels: [UILabel]!
    
    
    var randomNumber = Int.random(in: 1...50)
    var lowestNumber = 0
    var highestNumber = 50
    var chance = 6
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameInit()

    }
    //鍵盤縮放
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    func gameInit() {
        //初始遊戲函數
        randomNumber = Int.random(in: 1...50)
        lowestNumber = 0
        highestNumber = 50
        chance = 6
        
        rangeLabel.text = "Range: \(lowestNumber) ~ \(highestNumber)"
        chanceWithImage(index: chance)
        
        //迴圈使數字範圍之Label 改變背景顏色及翻牌效果
        for (i,_) in numberTrackerLabels.enumerated() {
            numberTrackerLabels[i].backgroundColor = UIColor.init(named: "TextColor")
            UIView.transition(with: numberTrackerLabels[i], duration: 0.8, options: .transitionCurlDown, animations: nil, completion: nil)
        }
        
    }
    //迴圈：表示遊戲次數之UIImage
    func chanceWithImage(index:Int) {
        //將chance次數(6次)反之由1開始
        let reverse = 5 - index
        for (i,_) in chanceImages.enumerated() {
            if i > reverse {
                chanceImages[i].isHighlighted = false
            }else {
                chanceImages[i].isHighlighted = true
            }
        }
    }
    
    func numberRangeTracker () {
        for (i,_) in numberTrackerLabels.enumerated() {
            if i < lowestNumber {
                numberTrackerLabels[i].backgroundColor = UIColor.white
                UIView.transition(with: numberTrackerLabels[i], duration: 0.8, options: .transitionCurlDown, animations: nil, completion: nil)
            }else if i > highestNumber-2 {
                numberTrackerLabels[i].backgroundColor = UIColor.white
                UIView.transition(with: numberTrackerLabels[i], duration: 0.8, options: .transitionCurlUp, animations: nil, completion: nil)
            }
            
        }
        
    }
    
    
    @IBAction func guessNumber(_ sender: Any) {
        //TextField文字轉數字
        let enterNumber = Int(numberTextField.text!)
        
        //判斷:猜數是否正確
        if numberTextField.text! == String(randomNumber) {
            numberTrackerLabels[randomNumber-1].backgroundColor = UIColor.red
            let winAlertController = UIAlertController(title: "\(randomNumber) Bingo!", message: "Weldone!", preferredStyle: .alert)
            let winAlertAction = UIAlertAction(title: "Restart", style: .default) {
                (_) in
                self.gameInit()
            }
            winAlertController.addAction(winAlertAction)
            present(winAlertController, animated: true, completion: nil)
            
        //判斷：猜數大於答案
        }else if numberTextField.text! > String(randomNumber) {
            //當猜數超過範圍/非數字，跳出Alert，再猜一次（??未輸入數字則等於原輸入之數字(default)）
            if enterNumber ?? highestNumber >= highestNumber || enterNumber ?? lowestNumber <= lowestNumber {
                let overNumberAlertController = UIAlertController(title: "Check Again!", message: "Number should be within \(lowestNumber) ~ \(highestNumber)", preferredStyle: .alert)
                let overNumberAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                overNumberAlertController.addAction(overNumberAlertAction)
                present(overNumberAlertController, animated: true, completion: nil)
                
            //當猜數大於答案，且在範圍內: 遊戲次數-1，func遊戲對應之image，猜數存入最高數
            }else{
                chance-=1
                chanceWithImage(index: chance)
                highestNumber = enterNumber!
                
            }
        //判斷：猜數小於答案
        }else{
            //當猜數超過範圍/非數字，跳出Alert，再猜一次
            if enterNumber ?? highestNumber >= highestNumber || enterNumber ?? lowestNumber <= lowestNumber {
                let overNumberAlertController = UIAlertController(title: "Check Again!", message: "Number should be within \(lowestNumber) ~ \(highestNumber)", preferredStyle: .alert)
                let overNumberAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                overNumberAlertController.addAction(overNumberAlertAction)
                present(overNumberAlertController, animated: true, completion: nil)
                
            //當猜數小於於答案，且在範圍內: 遊戲次數-1，func遊戲對應之image，猜數存入最低數
            }else {
                chance-=1
                chanceWithImage(index: chance)
                lowestNumber = enterNumber ?? lowestNumber
                
            }
            
        }
        numberRangeTracker()
        
        //當猜數次數為0，跳出Alert遊戲重新開始
        if chance == 0 {
            numberTrackerLabels[randomNumber].backgroundColor = UIColor.red
            let runOutOfChanceAlertController = UIAlertController(title: "次數用完啦！", message: "答案是 \(randomNumber)", preferredStyle: .alert)
            let runOutOfChanceAlertAction = UIAlertAction(title: "Restart", style: .default) { (_) in
                self.gameInit()
            }
            
            runOutOfChanceAlertController.addAction(runOutOfChanceAlertAction)
            present(runOutOfChanceAlertController, animated: true, completion: nil)
            
        }
        rangeLabel.text = "Range: \(lowestNumber) ~ \(highestNumber)"
        numberTextField.text = nil
        
    }
    
}

