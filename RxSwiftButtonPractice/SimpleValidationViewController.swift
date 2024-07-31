//
//  SimpleValidationViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/31/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class SimpleValidationViewController: UIViewController {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    let usernameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        return label
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let usernameValidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .left
        return label
    }()
    
    let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let passwordValidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .left
        return label
    }()
    
    let completeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = UIButton.Configuration.filled()
        btn.setTitle("완료", for: .normal)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureLayout()
        configureUI()
    }
    
    //MARK: - Configurations
    
    func bind() {
        
        let debug = Observable.just("USERNAME").debug("username")
        let debug2 = Observable.just("PASSWORD").debug("username")
        
        let usernameValid = usernameTextField.rx.text.orEmpty
            .flatMap { _ in debug }
            .map { $0.count >= 5 }
            .share(replay: 1) //1: 최신값 방출
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .flatMap { _ in debug2 }
            .map { $0.count >= 5 }
            .share(replay: 1) //1: 최신값 방출
        
        usernameValid
            .bind(onNext: { value in
                self.passwordTextField.isEnabled = value
            })
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(onNext: { value in
                self.usernameValidLabel.isHidden = value
            })
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { isUsernameValid, isPasswordValid in
            let result = isUsernameValid && isPasswordValid
            return result
        }
        
        everythingValid
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        view.addSubview(usernameTitleLabel)
        usernameTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }
        
        view.addSubview(usernameValidLabel)
        usernameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        view.addSubview(passwordTitleLabel)
        passwordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameValidLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }
        
        view.addSubview(passwordValidLabel)
        passwordValidLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(passwordValidLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
        usernameValidLabel.text = "최소 5자리 이상으로 입력해야 합니다."
        passwordValidLabel.text = "최소 5자리 이상으로 입력해야 합니다."
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "가입 완료", message: "회원가입 되셨습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

}
