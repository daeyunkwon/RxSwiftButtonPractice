//
//  SimplePickerViewExampleViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/31/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class SimplePickerViewExampleViewController: UIViewController {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureLayout()
        configureUI()
    }
    
    //MARK: - Configurations
    
    func bind() {
        
        let items = Observable.just([1, 2, 3]).share(replay: 1)
        
        items
            .bind(to: pickerView1.rx.itemTitles) { row, element in
                return String(element)
            }
            .disposed(by: disposeBag)
        
        items
            .bind(to: pickerView2.rx.itemAttributedTitles) { row, element in
                return NSAttributedString(string: String(element), attributes: [.foregroundColor: UIColor.systemBlue,
                                                                                .underlineStyle: NSUnderlineStyle.single.rawValue
                                                                               ])
            }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .map({ list in
                list.first
            })
            .subscribe(with: self) { owner, value in
                print("pickerView1 선택: \(value ?? 0)")
            }
            .disposed(by: disposeBag)
        
        pickerView2.rx.modelSelected(Int.self)
            .map({ list in
                list.first
            })
            .subscribe(with: self) { owner, value in
                print("pickerView2 선택: \(value ?? 0)")
            }
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.red, UIColor.blue, UIColor.green])
            .bind(to: pickerView3.rx.items) { row, element, view in
                let view = UIView()
                view.backgroundColor = element
                return view
            }
            .disposed(by: disposeBag)
        
        pickerView3.rx.modelSelected(UIColor.self)
            .map({ list in
                list.first
            })
            .bind(to: pickerView1.rx.backgroundColor)
            .disposed(by: disposeBag)
        
    }
    
    private func configureLayout() {
        view.addSubview(pickerView1)
        pickerView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(pickerView2)
        pickerView2.snp.makeConstraints { make in
            make.top.equalTo(pickerView1.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        view.addSubview(pickerView3)
        pickerView3.snp.makeConstraints { make in
            make.top.equalTo(pickerView2.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
    }
    
    //MARK: - Methods
    

    
    
}

