//
//  LearnViewController.swift
//  SunBlocker
//
//  Created by Ricardo Fernandez on 2/3/23.
//

import UIKit

class LearnViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .black
        textView.textAlignment = .center
        view.addSubview(textView)
        
        let items = [ "Protection against skin cancer: Sunscreen helps to protect the skin from the damaging effects of ultraviolet (UV) radiation, which is a major cause of skin cancer.",
                      "Prevents sunburn: Sunscreen forms a barrier on the skin that absorbs or reflects the UV rays, preventing them from penetrating the skin and causing sunburn.",
                      "Reduces the risk of premature aging: Regular use of sunscreen helps to prevent premature aging signs such as wrinkles, fine lines, and age spots caused by prolonged sun exposure.",
                      "Minimizes the risk of hyperpigmentation: Sunscreen prevents the overproduction of melanin, the pigment responsible for dark spots and hyperpigmentation. It helps to maintain an even skin tone.",
                      "Shields against UVA and UVB rays: Sunscreen provides protection against both UVA and UVB rays. UVA rays can cause long-term skin damage and premature aging, while UVB rays are responsible for sunburn and immediate skin damage.",
                      "Preserves skin health: Sunscreen protects the skin's DNA by reducing the occurrence of DNA mutations caused by UV radiation. It helps maintain overall skin health.",
                      "Prevents sun-related allergies: Some people may be prone to sun allergies or have sensitive skin that reacts to sunlight. Sunscreen forms a protective layer, minimizing the risk of allergic reactions and skin irritations.",
                      "Supports post-treatment skin care: After undergoing procedures such as chemical peels, laser treatments, or microdermabrasion, the skin becomes more sensitive to sunlight. Sunscreen helps protect the skin during the healing process.",
                      "Maintains an even complexion: Sunscreen prevents the skin from tanning unevenly or developing a blotchy appearance due to sun exposure. It helps maintain a more youthful and radiant complexion.",
                      "Promotes long-term skin health: Consistent use of sunscreen throughout your life can significantly reduce the risk of various skin conditions and maintain the overall health and appearance of your skin."]
        
      
        let listString = items.enumerated().map { index, item in
            "\(index + 1). \(item)"
        }.joined(separator: "\n\n")
        
        textView.text = listString
    }
}







