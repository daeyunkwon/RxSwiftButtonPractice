//
//  AddingNumbersViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/31/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class AddingNumbersViewController: UIViewController {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    
    //MARK: - UI Components
    
    let firstNumberTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.textAlignment = .right
        return tf
    }()
    
    let secondNumberTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.textAlignment = .right
        return tf
    }()
    
    let thirdNumberTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.textAlignment = .right
        return tf
    }()
    
    let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "None"
        return label
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
        
        Observable.combineLatest(firstNumberTextField.rx.text.orEmpty, secondNumberTextField.rx.text.orEmpty, thirdNumberTextField.rx.text.orEmpty) { value1, value2, value3 -> Int in
            let firstNumber = (Int(value1) ?? 0)
            let secondNumber = (Int(value2) ?? 0)
            let thirdNumber = (Int(value3) ?? 0)
            return firstNumber + secondNumber + thirdNumber
        }
        .map{ String($0) }
        .bind(to: resultLabel.rx.text) //bind(to:)를 통해 선언형 프로그래밍 방식으로 처리 가능하게 지원하는 것. UI 컴포넌트와 간단히 연결해서 처리.
//        .subscribe(with: self) { owner, value in
//            owner.resultLabel.text = value
//        }
        .disposed(by: disposeBag)
        
    }
    
    private func configureLayout() {
        view.addSubview(firstNumberTextField)
        firstNumberTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        view.addSubview(secondNumberTextField)
        secondNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNumberTextField.snp.bottom).offset(5)
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(thirdNumberTextField)
        thirdNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(secondNumberTextField.snp.bottom).offset(5)
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(plusLabel)
        plusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(thirdNumberTextField)
            make.trailing.equalTo(thirdNumberTextField.snp.leading).offset(-5)
        }
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(thirdNumberTextField.snp.bottom).offset(5)
            make.leading.equalTo(plusLabel)
            make.trailing.equalTo(thirdNumberTextField)
            make.height.equalTo(0.5)
        }
        
        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.leading.equalTo(plusLabel)
            make.trailing.equalTo(thirdNumberTextField)
            make.top.equalTo(separatorView).offset(10)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
    }

}

