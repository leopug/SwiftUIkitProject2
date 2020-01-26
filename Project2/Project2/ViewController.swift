import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    var totalQuestionsAsked = 3
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let savedHighScore = defaults.object(forKey: "HighScore") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                highScore = try jsonDecoder.decode(Int.self, from: savedHighScore)
            } catch {
                print("errrroooorr")
            }
        }
        
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria",
        "poland","russia","spain","uk","us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(getScore))
    }

    func askQuestion(_ action: UIAlertAction! = nil){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        title = "\(countries[correctAnswer].uppercased()) - Score: \(score)"
        
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var alertTitle: String
        var finalAlertTitle: String
        
        if sender.tag == correctAnswer {
            alertTitle = "Correct"
            score += 1
        } else{
            alertTitle = "Wrong"
            score -= 1
        }
        
        if questionsAsked < totalQuestionsAsked {
            questionsAsked += 1
        }
        
        if alertTitle == "Wrong" {
            finalAlertTitle = " Wrong!!! The that`s the \(countries[sender.tag]). " + "Your score is \(score)"
        }else {
            finalAlertTitle =  "Correct!!! Your score is \(score)"
        }
        
        if questionsAsked == totalQuestionsAsked {
            
            if score > highScore {
                highScore = score
                save()
            }
            
            let finalAlertController = UIAlertController(title: alertTitle, message: "You have" +
                " reached the final frontier of \(totalQuestionsAsked) questions asked. " +
                "Your score is \(score)", preferredStyle: .alert)
            
            finalAlertController.addAction(UIAlertAction(title: "Continue", style: .default , handler: nil))
            
            present(finalAlertController, animated: true)
        } else {
            
            let ac = UIAlertController(title: alertTitle, message:finalAlertTitle , preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .default , handler: askQuestion))
            present(ac, animated: true)
        }
        
        title = "\(countries[correctAnswer].uppercased()) - Score: \(score)"
        
    }
    
    @objc func getScore(){
        let alertController = UIAlertController(title: "SCORE", message: "\(score) and high score is \(highScore)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "SCORE", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController,animated: true)
    }
   
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "HighScore")
        } else {
            print("We failed to save the high score")
        }
    }
    
}
