//
//  TableViewController.swift
//  RxSwiftButtonPractice
//
//  Created by 권대윤 on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class TableViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tv
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        configureLayout()
    }
    
    func setupTableView() {
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item",
        ])
        
        items.bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = element
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .map({ data in
                "\(data)를 선택했습니다"
            })
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    
}
