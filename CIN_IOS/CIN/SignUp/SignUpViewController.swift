//
//  SignUpViewController.swift
//  CIN
//
//  Created by 유호준 on 2021/08/20.
//

import RIBs
import RxSwift
import UIKit

protocol SignUpPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {

    weak var listener: SignUpPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK: - Preview

#if canImport(SwiftUI) &&  DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct SignUpViewRepresentable: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: UIViewRepresentableContext<SignUpViewRepresentable>) -> UIView {
        SignUpViewController().view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SignUpViewRepresentable>){
    
    }
}

struct SignUptViewPreview: PreviewProvider {
    static var previews: some View {
        SignUpViewRepresentable().previewLayout(.sizeThatFits)
    }
}
#endif
