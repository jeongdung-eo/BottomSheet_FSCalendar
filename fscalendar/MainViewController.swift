//
//  MainViewController.swift
//  fscalendar
//
//  Created by JEONGEUN KIM on 2022/12/20.
//

import UIKit
import Then
import SnapKit

class MainViewController: UIViewController,dateDelegate {
    var date = Date()
    private lazy var titleLabel = UILabel().then{
        $0.text = "실천 날짜"
    }
    private lazy var dateBtn = UIButton(configuration: .filled()).then {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let str = dateFormatter.string(from: nowDate)
        $0.configuration?.title = str
        $0.configuration?.image = UIImage(systemName: "calendar")
        $0.configuration?.imagePadding = 10
        $0.configuration?.imagePlacement = NSDirectionalRectEdge.trailing
        $0.configuration?.baseBackgroundColor = UIColor.custom_light_gray
        $0.configuration?.baseForegroundColor = .black
        $0.configuration?.cornerStyle = .medium
        $0.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViews()
        setConstraints()
        
    }
    func setViews(){
        view.addSubview(titleLabel)
        view.addSubview(dateBtn)
    }
    func setConstraints(){
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        dateBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.width.equalTo(150)
        }
    }
    func updateData(date : String){
        dateBtn.setTitle(date, for: .normal)
    }
    @objc func btnTapped(_sender : UIButton){
        print("tapped")
        let dateVC = ViewController()
        present(dateVC, animated: true, completion: nil)
        dateVC.dateSendDelegate = self
    }
}

