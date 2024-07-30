//
//  PickerViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class PickerViewController: UIViewController {
    
    let pickView = UIPickerView()
    
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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        configureLayout()
        configureUI()
    }
    
    func setupPickerView() {
        let items = Observable.just(["영화", "드라마", "애니메이션", "기타"])
    
        items.bind(to: pickView.rx.itemTitles) { row, element in
            return element
        }
        .disposed(by: disposeBag)
        
        pickView.rx.modelSelected(String.self)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, value in
                owner.label.text = value.first
            })
            .disposed(by: disposeBag)
            
            
    }
    
    func configureLayout() {
        view.addSubview(pickView)
        pickView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(pickView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    
    
}
