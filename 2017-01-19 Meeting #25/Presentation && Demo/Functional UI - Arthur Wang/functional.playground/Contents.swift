import UIKit

var text = "make me functional"
let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 200))

func render() {
    for sub in view.subviews {
        sub.removeFromSuperview()
    }
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 600, height: 200))
    label.font = UIFont.systemFont(ofSize: 40)
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.text = text
    view.addSubview(label)
}

render()
view
text = "change text to something else"
render()
view


//let textField = UITextField(frame: CGRect(x: 0, y: 50, width: 600, height: 50))
//textField.backgroundColor = UIColor.white
//view.addSubview(textField)
//view


