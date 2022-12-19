//
//  ViewController.swift
//  fscalendar
//
//  Created by JEONGEUN KIM on 2022/12/19.
//

import UIKit
import FSCalendar
import SnapKit
import Then
protocol dateDelegate {
    func updateData(date : String)
}
class CalendarVC: UIViewController{
    var dateSendDelegate : dateDelegate? = nil
    fileprivate weak var calendar: FSCalendar!
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private lazy var hStack = UIStackView(arrangedSubviews: [leftBtn,rightBtn]).then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    private lazy var headerLabel = UILabel().then{
        $0.text = self.dateFormatter.string(from: calendar.currentPage)
        $0.textColor = .black
    }
    private lazy var leftBtn = UIButton().then{
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .custom_light_gray
        $0.addTarget(self, action: #selector(prevBtnTapped), for: .touchUpInside)
    }
    private lazy var rightBtn = UIButton().then{
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .custom_light_gray
        $0.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
    }
    private lazy var confirmBtn = UIButton().then{
        $0.setTitle("선택 완료", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(confimTapped), for: .touchUpInside)
    }
    private var currentPage: Date?
    private lazy var today: Date = { return Date() }()
    private lazy var dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.dateFormat = "yyyy년 M월"
    }
    @objc func prevBtnTapped(_sender : UIButton){
        scrollCurrentPage(isPrev: true)
    }
    @objc func nextBtnTapped(_sender : UIButton){
        scrollCurrentPage(isPrev: false)
    }
    @objc func confimTapped(_sender : UIButton){
        self.dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarColor()
        setCalendar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let calendar = FSCalendar(frame: .zero)
        calendar.dataSource = self
        calendar.delegate = self
        self.calendar = calendar
        calendarText()
        setViews()
        setConstraints()
        calendarColor()
        setUpCalendar()
    }
    private func setViews(){
        view.addSubview(headerLabel)
        view.addSubview(hStack)
        view.addSubview(calendar)
        view.addSubview(confirmBtn)

    }
    private func setConstraints(){
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().offset(50)
        }
        hStack.snp.makeConstraints {
            $0.top.equalTo(headerLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(45)
        }
        calendar.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(242)
        }
        confirmBtn.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(30)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

    }
    private func calendarText(){
        calendar.calendarHeaderView.isHidden = true
        calendar.calendarWeekdayView.weekdayLabels[0].text = "월"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "화"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "수"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "목"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "금"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "토"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "일"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
    }
    private func calendarColor() {
        calendar.appearance.weekdayTextColor = .custom_gray // 달력의 요일 글자 색상
        calendar.appearance.selectionColor = .custom_gray //선택한 날짜 동그라미 색상
        calendar.appearance.titleSelectionColor = .white //선택한 날짜 글자 색상
        calendar.today = nil  // Hide the today circle
        }
    private func setUpCalendar(){
        self.calendar.placeholderType = .fillHeadTail  //달력 필요한 부분만 보이게
        self.calendar.firstWeekday = 2 //월요일부터 시작
    }
    private func scrollCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
}
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func setCalendar() {
        calendar.headerHeight = 0
        calendar.scope = .month
        headerLabel.text = self.dateFormatter.string(from: calendar.currentPage)
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
        self.headerLabel.text = self.dateFormatter.string(from: calendar.currentPage)
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor?{
        let monthOfDate = Calendar.current.component(.month, from: date)
        let monthOfCal = Calendar.current.component(.month, from: calendar.currentPage)
        let isInDisplayedMonth = monthOfDate == monthOfCal
        let day = Calendar.current.component(.weekday, from: date) - 1
        if Calendar.current.shortWeekdaySymbols[day] == "일" && isInDisplayedMonth {
            return .custom_red
        }else if Calendar.current.shortWeekdaySymbols[day] == "토"  && isInDisplayedMonth{
            return .black
        } else { return nil}
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "yyyy.MM.dd"
        print(dateFormatter.string(from: date))
           self.dateSendDelegate?.updateData(date : dateFormatter.string(from: date))
    }
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 해제됨")
    }
}

