//
//  DayPickerComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct DayPickerComponentView: View {
    let id: String
    let title: String?

    @Binding var selectedDays: Set<DayOfWeek>
    @FocusState.Binding var focusedField: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title)
                    .body_01(.grey900)
            }

            HStack {
                ForEach(DayOfWeek.allCases, id: \.self) { day in
                    Button {
                        toggle(day)
                    } label: {
                        Text(day.localizedLabel)
                            .body_03(selectedDays.contains(day) ? .primaryPurple : .grey300)
                            .frame(width: 40, height: 40)
                            .background(selectedDays.contains(day) ? Color.primaryPurple100 : Color.grey100)
                            .foregroundColor(selectedDays.contains(day) ? .white : .grey500)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(selectedDays.contains(day) ? Color.primaryPurple : Color.grey100, lineWidth: 1)
                            )
                    }
                    .animation(.easeInOut(duration: 0.2), value: selectedDays)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func toggle(_ day: DayOfWeek) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
}

#Preview {
    @Previewable @State var selectedDays: Set<DayOfWeek> = []
    @FocusState var focusedField: String?

    DayPickerComponentView(id: "DayPicker", title: "운영요일", selectedDays: $selectedDays, focusedField: $focusedField)
}
