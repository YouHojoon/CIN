//
//  SignUpInteractor.swift
//  CIN
//
//  Created by 유호준 on 2021/08/20.
//

import RIBs
import RxSwift

protocol SignUpRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SignUpPresentable: Presentable {
    var listener: SignUpPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SignUpListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable, SignUpPresentableListener {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SignUpPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func passwordVerification(password: String) -> Bool {
        if password.isEmpty == false{
            if password.count >= 8{
                return true
            }
        }
        
        return false
    }
    
    func nameVerification(name: String) -> Bool {
        if name.isEmpty == false{
            if name.count >= 2{
                return true
            }
        }
        
        return false
    }
    
    func phoneVerification(middle: String, last: String) -> Bool {
        if middle.count < 3 || last.count < 4{
            return false
        }
        else{
            return true
        }
    }
}
