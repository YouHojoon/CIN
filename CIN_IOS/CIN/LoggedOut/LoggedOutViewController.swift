//
//  LoggedOutViewController.swift
//  CIN
//
//  Created by 유호준 on 2021/08/19.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import Then
import SnapKit

protocol LoggedOutPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    
    func doSignUp()
}
	
final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {
    
    weak var listener: LoggedOutPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setLayout()
        self.setButton()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    func present(viewController: ViewControllable) {
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.modalTransitionStyle = .crossDissolve
        
        self.present(viewController.uiviewController, animated: true, completion: nil)
    }
    
    func dismiss(viewController: ViewControllable) {
        if presentedViewController === viewController.uiviewController{
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.disposeBag = DisposeBag()
    }
    //MARK: - Private

    private weak var idTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var strikeThroughView: UIView!
    
    private weak var loggedInButton: UIButton!
    private weak var findIdButton: UIButton!
    private weak var findPasswordButton: UIButton!
    private weak var signUpButton: UIButton!
    
    private weak var titleLabel1: UILabel!
    private weak var titleLabel2: UILabel!
    private weak var titleLabel3: UILabel!
    
    private var disposeBag = DisposeBag()

    private func setLayout(){  
        self.titleLabel1 = UILabel().then{
            $0.text = "Camping"
            $0.font = .boldSystemFont(ofSize: 80)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(120)
                $0.leading.equalTo(self.view).inset(30)
            }
        }
        
        self.titleLabel2 = UILabel().then{
            $0.text = "is"
            $0.font = .boldSystemFont(ofSize: 55)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.titleLabel1.snp.bottom).offset(1)
                $0.centerX.equalTo(self.view).offset(30)
            }
        }
        
        self.titleLabel3 = UILabel().then{
            $0.text = "Now!"
            $0.font = .boldSystemFont(ofSize: 70)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.titleLabel2.snp.bottom).offset(-10)
                $0.centerX.equalTo(self.view).offset(30)
            }
        }
        
        self.idTextField = UITextField().then{
            $0.placeholder = "ID"
            $0.borderStyle = .roundedRect
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.centerX.equalTo(self.view)
                $0.top.equalTo(self.titleLabel3.snp.bottom).offset(70)
                $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
                $0.height.equalTo(50)
            }
        }
        
        self.passwordTextField = UITextField().then{
            $0.placeholder = "Password"
            $0.borderStyle = .roundedRect
            $0.textContentType = .password
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.idTextField.snp.bottom).offset(15)
                $0.centerX.equalTo(self.view)
                $0.width.equalTo(self.idTextField)
                $0.height.equalTo(self.idTextField.snp.height)
            }
        }
        
        self.strikeThroughView = UIView().then{
            $0.backgroundColor = .systemGreen
            $0.alpha = 0.5
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.width.equalTo(self.idTextField.snp.width)
                $0.height.equalTo(5)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-80)
                $0.centerX.equalTo(self.view)
            }
        }
        
    }
    
    private func setButton(){
        self.loggedInButton = UIButton().then{
            $0.setTitle("로그인", for: .normal)
            $0.backgroundColor = .systemGreen
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 5
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.width.equalTo(100)
                $0.centerX.equalTo(self.view)
                $0.top.equalTo(self.passwordTextField.snp.bottom).offset(80)
            }
        }
        
        self.findPasswordButton = UIButton().then{
            $0.setTitle("비밀번호 찾기", for: .normal)
            $0.setTitleColor(.systemGreen, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.setBackgroundColor(.systemGray, for: .highlighted)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.size.equalTo(CGSize(width: 100, height: 50))
                $0.centerX.equalTo(self.view)
                $0.top.equalTo(self.strikeThroughView).offset(20)
            }
        }
        
        self.findIdButton = UIButton().then{
            $0.setTitle("아이디 찾기", for: .normal)
            $0.setTitleColor(.systemGreen, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.setBackgroundColor(.systemGray, for: .highlighted)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.size.equalTo(self.findPasswordButton.snp.size)
                $0.leading.equalTo(self.strikeThroughView.snp.leading)
                $0.top.equalTo(self.findPasswordButton)
            }
        }
        
        self.signUpButton = UIButton().then{
            $0.setTitle("회원가입", for: .normal)
            $0.setTitleColor(.systemGreen, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.setBackgroundColor(.systemGray, for: .highlighted)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.size.equalTo(CGSize(width: 100, height: 50))
                $0.trailing.equalTo(self.strikeThroughView)
                $0.top.equalTo(self.findPasswordButton)
            }
            
            $0.rx.tap.take(1).subscribe(onNext: {[weak self] _  in self?.listener?.doSignUp()})
                .disposed(by: disposeBag)
        }
    }
}

//MARK: - Preview

#if	canImport(SwiftUI) &&  DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct LoggedOutViewRepresentable: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: UIViewRepresentableContext<LoggedOutViewRepresentable>) -> UIView {
        LoggedOutViewController().view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoggedOutViewRepresentable>){
    
    }
}

struct LoggedOutViewPreview: PreviewProvider {
    static var previews: some View {
        LoggedOutViewRepresentable().previewLayout(.sizeThatFits)
    }
}
#endif
