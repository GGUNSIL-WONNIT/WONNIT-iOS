//
//  FocusStateStore.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI
import CoreLocation

@Observable
final class FormStateStore: NSObject {
    var focusedID: String? = nil
    
    func focus(_ id: String?) { focusedID = id }
    func blur() { focusedID = nil }
    
    @objc func handleDone() { blur() }
    
    var textValues: [String: String] = [:]
    var doubleValues: [String: Double?] = [:]
    var intValues: [String: Int?] = [:]
    var daySetValues: [String: Set<DayOfWeek>] = [:]
    var timeRangeValues: [String: TimeRange] = [:]
    var selectValues: [String: String?] = [:]
    var tagsValues: [String: [String]] = [:]
    var amountInfoValues: [String: AmountInfo] = [:]
    var imageValues: [String: [UIImage]] = [:]
    var roomDataValues: [String: RoomData?] = [:]
    var addressValues: [String: KakaoAddress?] = [:]
    var coordinateValues: [String: CLLocationCoordinate2D?] = [:]
    
#if DEBUG
    func fillWithDebugPlaceholderData() {
        addressValues["address1"] = KakaoAddress(roadAddress: "서울 노원구 공릉로 232", jibunAddress: "서울 노원구 공릉동 172", zonecode: "000000")
        coordinateValues["address1"] = CLLocationCoordinate2D(latitude: 37.62990, longitude: 127.07972)
        textValues["address2"] = "서울과학기술대학교"
        textValues["name"] = "Test Space"
        doubleValues["area"] = 77.7
        imageValues["mainImage"] = [UIImage(systemName: "photo.artframe")!]
        imageValues["subImages"] = [UIImage(systemName: "photo.on.rectangle")!]
        selectValues["category"] = "STUDY_ROOM"
        tagsValues["tags"] = ["책상", "의자"]
        daySetValues["openDay"] = [.MONDAY, .TUESDAY, .WEDNESDAY, .THURSDAY, .FRIDAY]
        timeRangeValues["openTime"] = TimeRange(startAt: DateComponents(hour: 9, minute: 30), endAt: DateComponents(hour: 22, minute: 0))
        amountInfoValues["pricing"] = AmountInfo(timeUnit: .perHour, amount: 12000)
        textValues["contact"] = "010-1234-5678"
        textValues["cautions"] = "어쩌고"
    }
#endif
}
