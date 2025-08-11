//
//  TimeRangePickerComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct TimeRangePickerComponentView: View {
    let config: FormFieldBaseConfig
    @Environment(FormStateStore.self) private var store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                Text(title).body_02(.grey900)
            }
            
            TimeRangePickerBridge(
                id: config.id,
                store: store,
                value: store.timeRangeBinding(for: config.id),
                style: PickerStyleColorsMapping(
                    textSelected: UIColor(Color.grey900),
                    textNormal: UIColor(Color.grey900),
                    bgSelected: UIColor(Color.white),
                    bgNormal: UIColor(Color.white),
                    borderSelected: UIColor(Color.primaryPurple),
                    borderNormal: UIColor(Color.grey100)
                )
            )
            .frame(height: 48)
        }
    }
}
