//
//  TextFieldViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class TextFieldViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.label.cgColor
        label.layer.borderWidth = 1
        label.text = "Label"
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = UIButton.Configuration.filled()
        btn.setTitle("Button", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSign()
        
        view.backgroundColor = .systemBackground
        configureLayout()
    }
    
    func setupSign() {
        Observable.combineLatest(nameTextField.rx.text.orEmpty, emailTextField.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, email은 \(value2) 입니다."
        }
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .map {$0.count < 4}
//            .bind(onNext: { value in
//                print(value)
//                self.emailTextField.isHidden = value
//                self.button.isHidden = value
//            })
            .bind(to: emailTextField.rx.isHidden, button.rx.isHidden)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(with: self) { owner, value in
                owner.button.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        button.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                self.showAlert()
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "알림", message: "가입 완료!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func configureLayout() {
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalTo(button.snp.top).offset(-20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
}
