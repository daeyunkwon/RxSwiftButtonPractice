//
//  ViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

//MARK: - 버튼 탭 시 레이블에 글자 보여주기

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
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
        // Do any additional setup after loading the view.
        configureLayout()
        configureUI()
        bind()
        
    }
    
    func bind() {
        //Observable: 버튼의 터치 이벤트 | Observer: UILabel
        
        //기본 형태
        button.rx.tap
            .subscribe { _ in
                self.label.text = "버튼 클릭됨1"
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed!")
            } onDisposed: {
                print("disposed!")
            }
            .disposed(by: disposeBag)
        
        //간단한 형태로 만들기
        button.rx.tap
            .subscribe { _ in
                self.label.text = "버튼 클릭2"
            }
            .disposed(by: disposeBag)
        
        //self 약한 참조로 동작시키기
        button.rx.tap
            .withUnretained(self)
            .subscribe { _ in
                self.label.text = "버튼 클릭3"
            }
            .disposed(by: disposeBag)
        
        //self 약한 참조로 동작시키기
        button.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.label.text = "버튼 클릭4"
            }
            .disposed(by: disposeBag)
        
        //메인쓰레드에서 동작시키기
        button.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.label.text = "버튼 클릭5"
            }
            .disposed(by: disposeBag)
        
        //메인쓰레드에서 동작시키기
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.label.text = "버튼 클릭6"
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureLayout() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }


}

