//
//  FormStateStoreBindings.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import Foundation
import SwiftUI

extension FormStateStore {
    func stringBinding(for id: String, default defaultValue: String = "") -> Binding<String> {
        Binding(
            get: { self.textValues[id] ?? defaultValue },
            set: { self.textValues[id] = $0 }
        )
    }
    
    func doubleBinding(for id: String) -> Binding<Double?> {
        Binding(
            get: { self.doubleValues[id] ?? nil },
            set: { self.doubleValues[id] = $0 }
        )
    }
    
    func intBinding(for id: String) -> Binding<Int?> {
        Binding(
            get: { self.intValues[id] ?? nil },
            set: { self.intValues[id] = $0 }
        )
    }
    
    func daysBinding(for id: String) -> Binding<Set<DayOfWeek>> {
        Binding(
            get: { self.daySetValues[id] ?? [] },
            set: { self.daySetValues[id] = $0 }
        )
    }
    
    //    func dayArrayBinding(for id: String) -> Binding<[DayOfWeek]> {
    //        Binding(
    //            get: {
    //                let set = self.daySetValues[id] ?? []
    //                return set.sorted { $0.rawValue < $1.rawValue }
    //            },
    //            set: { self.daySetValues[id] = Set($0) }
    //        )
    //    }
    
    func timeRangeBinding(
        for id: String,
        default defaultValue: TimeRange = .init(
            startAt: .init(hour: 9, minute: 0),
            endAt: .init(hour: 18, minute: 0)
        )
    ) -> Binding<TimeRange> {
        Binding<TimeRange>(
            get: { self.timeRangeValues[id] ?? defaultValue },
            set: { newValue in
                self.timeRangeValues[id] = newValue
                    .withNormalizedHM()
                    .orderedNonDecreasing()
            }
        )
    }
    
    func selectBinding(for id: String) -> Binding<String?> {
        Binding(
            get: { self.selectValues[id] ?? nil },
            set: { self.selectValues[id] = $0 }
        )
    }
    
    func amountInfoBinding(
        for id: String,
        default defaultValue: AmountInfo = .init(timeUnit: .perDay, amount: 0)
    ) -> Binding<AmountInfo> {
        Binding<AmountInfo>(
            get: { self.amountInfoValues[id] ?? defaultValue },
            set: { self.amountInfoValues[id] = $0 }
        )
    }
    
    func tagsBinding(for id: String) -> Binding<[String]> {
        Binding(
            get: { self.tagsValues[id] ?? [] },
            set: { self.tagsValues[id] = $0 }
        )
    }
    
    func imageBinding(for id: String) -> Binding<[UIImage]> {
        Binding(
            get: { self.imageValues[id] ?? [] },
            set: { self.imageValues[id] = $0 }
        )
    }
    
    func roomDataBinding(for id: String) -> Binding<RoomData?> {
        Binding(
            get: { self.roomDataValues[id, default: nil] },
            set: { self.roomDataValues[id] = $0 }
        )
    }
}
