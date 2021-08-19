//
//  RootRouter.swift
//  CIN
//
//  Created by 유호준 on 2021/08/19.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewControllable: ViewControllable)
    func dismiss(viewControllable: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    
    init(interactor: RootInteractable, viewController: RootViewControllable, loggedOutBuilder: LoggedOutBuildable) {
        self.loggedOutBuilder = loggedOutBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        self.routeToLoggedOut()
    }
    
    // MARK: - Private
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOut: ViewableRouting?
    
    private func routeToLoggedOut(){
        let loggedOut = loggedOutBuilder.build(withListener: self.interactor)
        
        self.loggedOut = loggedOut
        self.attachChild(loggedOut)
        
        guard let loggedOutView = self.loggedOut?.viewControllable.uiviewController else{return}
        loggedOutView.modalPresentationStyle = .fullScreen
        
        self.viewController.present(viewControllable: loggedOut.viewControllable)
    }
}
