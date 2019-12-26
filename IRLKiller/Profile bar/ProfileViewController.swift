import UIKit


class ProfileViewController: UIViewController {

    @IBOutlet weak var myLoginText:UILabel!
    @IBOutlet weak var myRatingText:UILabel!
    @IBOutlet var top: [UILabel]!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupViews(curView: firstView)
        setupViews(curView: secondView)
        
        let myLogin = DataBaseManager.myLogin
        myLoginText.text = myLogin
        let myRating = DataBaseManager.myRating
        myRatingText.textColor = UIColor.getRatingColor(for: myRating!)
        myRatingText.text = String(myRating!)
        
        let players = DataBaseManager.players.sorted(by: { $0.value.rating > $1.value.rating })
        
        var placeInTop = 0
        
        for player in players{
            if placeInTop == 10 { break }
            top[placeInTop].textColor = UIColor.getRatingColor(for: player.value.rating)
            top[placeInTop].text! = String(player.value.rating) + "   " + player.key
            print(player.value.rating,player.key)
            placeInTop+=1
        }
    }
    
    func setupViews(curView:UIView){
        curView.layer.cornerRadius = 10
        curView.layer.borderWidth = 3
        curView.layer.borderColor = UIColor.black.cgColor
        curView.clipsToBounds = true
    }
}
