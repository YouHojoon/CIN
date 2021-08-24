//
//  SignUpViewController.swift
//  CIN
//
//  Created by 유호준 on 2021/08/20.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import RxViewController
import RxDataSources
import TextFieldEffects

protocol SignUpPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func passwordVerification(password: String) -> Bool
    func nameVerification(name: String) -> Bool
    func phoneVerification(middle: String, last: String) -> Bool

}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {

    weak var listener: SignUpPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setLayout()
    }
    
    //MARK: - Private
    private let itemTopSpace = 15
    private let itemHorizontalIncest = 20
    private let errorLabelTopSpace = 5
    private let textFieldHeight = 50
    
    private var titleLabel: UILabel!
    
    private var idTextField: UITextField!
    private var idErrorLabel: UILabel!
    private var idDupCheckButton: UIButton!
    
    private var passwordTextField: UITextField!
    private var repeatPasswordTextField: UITextField!
    private var passwordErrorLabel: UILabel!
    private var repeatPasswordErrorLabel: UILabel!
    
    private var nameTextField: UITextField!
    private var nameErrorLabel: UILabel!
    
    private var phonePickerView: UIPickerView!
    private var phoneMiddleNum: UITextField!
    private var phoneLastNum: UITextField!
    private var phoneErrorLabel: UILabel!
    
    private var backButton: UIButton!
    private var submitButtom: UIButton!
    
    private var hostSegmentControl: UISegmentedControl!
    
    private let phonePerfix = ["010", "011"]
    private var disposeBag = DisposeBag()
    
    private func setLayout(){
        self.titleLabel = UILabel().then{
            $0.attributedText = NSAttributedString(string: "CIN", attributes: [.kern:3.5])
            $0.font = UIFont.boldSystemFont(ofSize: 50)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(self.itemHorizontalIncest)
                $0.centerX.equalToSuperview()
            }
        }
        
        self.setIdField()
        self.setPasswordField()
        self.setNameField()
        self.setPhoneField()
        
        self.hostSegmentControl = UISegmentedControl(items: ["게스트", "호스트"]).then{
            self.view.addSubview($0)
            $0.selectedSegmentIndex = 0
            $0.snp.makeConstraints{
                $0.top.equalTo(self.phoneErrorLabel.snp.bottom).offset(self.itemTopSpace)
                $0.leading.trailing.equalTo(self.view).inset(self.itemHorizontalIncest)
            }
        }
        
        self.setButton()
    }
    
    private func setIdField(){
        self.idTextField = UITextField().then{
            $0.placeholder = "ID"
            $0.borderStyle = .roundedRect
            
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.titleLabel.snp.bottom).offset(30)
                $0.leading.equalTo(self.view).offset(self.itemHorizontalIncest)
                $0.height.equalTo(self.textFieldHeight)
            }
        }
        
        self.idDupCheckButton = UIButton().then{
            $0.setTitle("중복확인", for: .normal)
            $0.backgroundColor = .systemGreen
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.width.equalTo(50)
                $0.height.equalTo(self.idTextField)
                $0.centerY.equalTo(self.idTextField.snp.centerY)
                $0.leading.equalTo(self.idTextField.snp.trailing).offset(10)
                $0.trailing.equalTo(self.view).inset(self.itemHorizontalIncest)
            }
        }
                
        self.idErrorLabel = UILabel().then{
            $0.text = "중복된 ID입니다."
            $0.textColor = .red
            $0.font = UIFont.systemFont(ofSize: 13)
//            $0.isHidden = true
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.idTextField.snp.bottom).offset(self.errorLabelTopSpace)
                $0.leading.equalTo(self.itemHorizontalIncest)
            }
        }
    }
    
    private func setPasswordField(){
        self.passwordTextField = UITextField().then{
            $0.placeholder = "Password"
            $0.borderStyle = .roundedRect
            $0.textContentType = .password
            self.view.addSubview($0)
            
            _ = $0.rx.text.orEmpty.skip(1).distinctUntilChanged().subscribe(onNext: {let isHidden = self.listener?.passwordVerification(password: $0)
                
                self.passwordErrorLabel.isHidden = isHidden ?? false
            }).disposed(by: disposeBag)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.idErrorLabel.snp.bottom).offset(self.itemHorizontalIncest)
                $0.leading.trailing.equalTo(self.view).inset(self.itemHorizontalIncest)
                $0.height.equalTo(self.textFieldHeight)
            }
        }
        
        
        
        self.passwordErrorLabel = UILabel().then{
            $0.text = "Password를 8자 이상을 입력해주세요."
            $0.textColor = .red
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.isHidden = true
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.passwordTextField.snp.bottom).offset(self.errorLabelTopSpace)
                $0.leading.equalTo(self.itemHorizontalIncest)
            }
        }
        
        self.repeatPasswordTextField = UITextField().then{
            $0.placeholder = "Password 재입력"
            $0.borderStyle = .roundedRect
            $0.textContentType = .password
            
            //Password 재입력 시 Password와 일치하는지
            _ = $0.rx.text.orEmpty.skip(1).distinctUntilChanged().subscribe(onNext: {self.repeatPasswordErrorLabel.isHidden = $0 == self.passwordTextField.text}).disposed(by: disposeBag)
            
            //Password 재입력이 공백이 아니고, Password 입력 시 Password 재입력과 일치하는지
            _ = $0.rx.text.orEmpty.skip(1).flatMap{_ in self.passwordTextField.rx.text.orEmpty.skip(1).distinctUntilChanged()}.subscribe(onNext: {self.repeatPasswordErrorLabel.isHidden = $0 == self.repeatPasswordTextField.text}).disposed(by: disposeBag)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.passwordErrorLabel.snp.bottom).offset(self.itemTopSpace)
                $0.leading.trailing.equalTo(self.view).inset(self.itemHorizontalIncest)
                $0.height.equalTo(self.textFieldHeight)
            }
        }
        
        self.repeatPasswordErrorLabel = UILabel().then{
            $0.text = "Password와 일치하지 않습니다."
            $0.textColor = .red
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.isHidden = true
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.repeatPasswordTextField.snp.bottom).offset(self.errorLabelTopSpace)
                $0.leading.equalTo(self.itemHorizontalIncest)
            }
        }
    }
    private func setNameField(){
        self.nameTextField = UITextField().then{
            $0.placeholder = "이름"
            $0.borderStyle = .roundedRect
            
            _ = $0.rx.text.orEmpty.skip(1).distinctUntilChanged().subscribe(onNext: {let isHidden = self.listener?.nameVerification(name: $0)
                
                self.nameErrorLabel.isHidden = isHidden ?? false
            }).disposed(by: disposeBag)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.repeatPasswordErrorLabel.snp.bottom).offset(self.itemTopSpace)
                $0.leading.trailing.equalTo(self.view).inset(self.itemHorizontalIncest)
                $0.height.equalTo(self.textFieldHeight)
            }
        }
        
        self.nameErrorLabel = UILabel().then{
            $0.text = "이름을 2자 이상 입력해주세요."
            $0.textColor = .red
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.isHidden = true
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.nameTextField.snp.bottom).offset(self.errorLabelTopSpace)
                $0.leading.equalTo(self.itemHorizontalIncest)
            }
        }
    }
    private func setPhoneField(){
        
        
        self.phonePickerView = UIPickerView().then{
            self.view.addSubview($0)
            
            _ = Observable.just(phonePerfix).bind(to: $0.rx.itemTitles){_, item in
                return item
            }.disposed(by: disposeBag)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.nameErrorLabel.snp.bottom).offset(self.itemTopSpace)
                $0.leading.equalTo(self.view).inset(self.itemHorizontalIncest)
                $0.height.equalTo(100)
            }
        }
        
        
        
        self.phoneLastNum = UITextField().then{textField in
            textField.placeholder = "0000"
            textField.textAlignment = .center
            textField.borderStyle = .roundedRect
            textField.keyboardType = .numberPad
            
            //글자 수 제한
            _ = textField.rx.controlEvent(.editingChanged).subscribe(onNext: {
                if let num = textField.text{
                    textField.text = String(num.prefix(4))
                }
            }).disposed(by: disposeBag)

            self.view.addSubview(textField)
            textField.snp.makeConstraints{
                $0.centerY.equalTo(self.phonePickerView.snp.centerY)
                $0.height.equalTo(self.textFieldHeight)
                $0.trailing.equalTo(self.view).inset(self.itemHorizontalIncest)
                $0.width.equalTo(self.phonePickerView)
            }
        }
        
        self.phoneMiddleNum = UITextField().then{textField in
            textField.placeholder = "0000"
            textField.textAlignment = .center
            textField.borderStyle = .roundedRect
            textField.keyboardType = .numberPad
            
            //글자 수 제한
            _ = textField.rx.controlEvent(.editingChanged).subscribe(onNext: {
                if let num = textField.text{
                    textField.text = String(num.prefix(4))
                }
            }).disposed(by: disposeBag)

            self.view.addSubview(textField)
            textField.snp.makeConstraints{
                $0.centerY.equalTo(self.phonePickerView.snp.centerY)
                $0.leading.equalTo(self.phonePickerView.snp.trailing).offset(20)
                $0.trailing.equalTo(self.phoneLastNum.snp.leading).offset(-20)
                $0.height.equalTo(self.textFieldHeight)
                $0.width.equalTo(self.phoneLastNum)
            }
        }
        
        self.phoneErrorLabel = UILabel().then{
            $0.text = "연락처를 올바르게 입력해주세요."
            $0.textColor = .red
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.isHidden = true
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.equalTo(self.phonePickerView.snp.bottom).offset(self.errorLabelTopSpace)
                $0.leading.equalTo(self.itemHorizontalIncest)
            }
        }
        
        //연락처 검증
        Observable.combineLatest(self.phoneMiddleNum.rx.text.orEmpty.skip(1).distinctUntilChanged(), self.phoneLastNum.rx.text.orEmpty.skip(1).distinctUntilChanged()){middle,last -> Bool in
            return self.listener?.phoneVerification(middle: middle, last: last) ?? false
        }.subscribe(onNext: {self.phoneErrorLabel.isHidden = $0}).disposed(by: disposeBag)
    }
    
    private func setButton(){
        self.backButton = UIButton().then{
            $0.setImage(UIImage(systemName: "arrow.backward.circle.fill"), for: .normal)
            $0.tintColor = .systemGreen
            self.view.addSubview($0)
            $0.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 35)
                                               , forImageIn: .normal)
            $0.snp.makeConstraints{
                $0.centerY.equalTo(self.titleLabel.snp.centerY)
                $0.leading.equalTo(self.view).inset(self.itemHorizontalIncest)
            }
        }
        
        self.submitButtom = UIButton().then{
            $0.setTitle("회원가입", for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .systemGreen
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{
                $0.centerX.equalTo(self.view)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(30)
                $0.width.equalTo(110)
            }
            
        }
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

struct SignUpViewPreview: PreviewProvider {

    static var previews: some View{
        SignUpViewRepresentable()
    }
}

#endif
