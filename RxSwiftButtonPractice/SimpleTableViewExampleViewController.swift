//
//  SimpleTableViewExampleViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/31/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class SimpleTableViewExampleViewController: UIViewController {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    var list = Array(repeating: "cell", count: 20) {
        didSet {
            self.itemSubject.onNext(self.list)
        }
    }
    
    var itemSubject = PublishSubject<[String]>()
    
    //MARK: - UI Components
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tv
    }()
    
    let addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = UIButton.Configuration.filled()
        btn.configuration?.cornerStyle = .capsule
        btn.setTitle("셀 추가하기", for: .normal)
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
        
        itemSubject
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element + " #\(row)"
            }
            .disposed(by: disposeBag)
        
        itemSubject.onNext(self.list)
        
        addButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.list.append("추가추가")
            }
            .disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(String.self)
//            .subscribe(with: self) { owner, value in
//                let message = "\(value)을 선택하셨습니다."
//                owner.showAlert(message: message)
//                owner.tableView.reloadData()
//            }
//            .disposed(by: disposeBag
        
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                let item = owner.list[indexPath.row]
                let message = "\(indexPath.row)번째 \(item)을 선택하셨습니다."
                owner.showAlert(message: message)
                owner.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
    }
    
    //MARK: - Methods
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "선택", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

}
