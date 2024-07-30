//
//  SwitchViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class SwitchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let mySwitch = UISwitch()
    
    lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = UIButton.Configuration.filled()
        btn.setTitle("Button", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwitch()
        setupButton()
        view.backgroundColor = .systemBackground
        configureLayout()
    }
    
    func setupButton() {
        button.rx.tap
            .bind(with: self) { owner, _ in
                var value = owner.mySwitch.isOn
                value.toggle()
                owner.mySwitch.setOn(value, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func setupSwitch() {
        Observable.of(false)
            .bind(with: self) { owner, value in
                owner.mySwitch.isOn = value
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(mySwitch)
        mySwitch.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
}
