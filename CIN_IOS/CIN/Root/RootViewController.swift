//
//  RootViewController.swift
//  CIN
//
//  Created by 유호준 on 2021/08/19.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func present(viewControllable: ViewControllable) {
        self.present(viewControllable.uiviewController, animated: false, completion: nil)
    }
    
    func dismiss(viewControllable: ViewControllable) {
        if viewControllable.uiviewController === presentedViewController {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
