//
//  LoggedOutRouter.swift
//  CIN
//
//  Created by 유호준 on 2021/08/19.
//

import RIBs

protocol LoggedOutInteractable: Interactable, SignUpListener {
    var router: LoggedOutRouting? { get set }
    var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class LoggedOutRouter: ViewableRouter<LoggedOutInteractable, LoggedOutViewControllable>, LoggedOutRouting {


    init(interactor: LoggedOutInteractable, viewController: LoggedOutViewControllable, signUpBuilder: SignUpBuilder){
        self.signUpBuilder = signUpBuilder
        super.init(interactor: interactor, viewController: viewController)
        self.interactor.router = self
        
    }
    
    func routeToSignUp(){
        let signUp = self.signUpBuilder.build(withListener: self.interactor)
        self.viewController.present(viewController: signUp.viewControllable)
        self.attachChild(signUp)
    }
    
    //MARK: - Private
    private let signUpBuilder: SignUpBuildable
    private var signUp: ViewableRouting?
    
    
}
