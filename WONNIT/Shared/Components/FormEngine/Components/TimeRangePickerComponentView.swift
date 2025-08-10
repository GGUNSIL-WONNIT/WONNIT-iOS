//
//  TimeRangePickerComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct TimeRangePickerComponentView: View {
    let config: FormFieldBaseConfig
    
    @Binding var selectedTimeRange: TimeRange
    @FocusState.Binding var focusedField: String?
    
    @State private var expanded: ExpandedField? = nil
    
    enum ExpandedField: Equatable {
        case startAt, endAt
    }
    
    var body: some View {
        ZStack {
            TextField("", text: .constant(""))
                .focused($focusedField, equals: config.id)
                .opacity(0)
                .frame(width: 0, height: 0)
                .disabled(true)
            
            VStack(alignment: .leading, spacing: 12) {
                if let title = config.title {
                    Text(title)
                        .body_02(.grey900)
                }
                
                HStack(spacing: 4) {
                    tappableTimeField(label: "시작", selection: $selectedTimeRange.startAt, field: .startAt)
                    Text("-")
                        .body_02(.grey900)
                    tappableTimeField(label: "종료", selection: $selectedTimeRange.endAt, field: .endAt)
                }
                
                if let expandedField = expanded {
                    wheel(selection: binding(for: expandedField))
                        .transition(.opacity)
                        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: expanded)
                }
            }
            .onChange(of: focusedField) { _, newValue in
                if newValue != config.id {
                    expanded = nil
                }
            }
        }
    }
    
    @ViewBuilder
    private func tappableTimeField(label: String, selection: Binding<DateComponents>, field: ExpandedField) -> some View {
        Button {
            withAnimation {
                expanded = (expanded == field) ? nil : field
            }
        } label: {
            HStack {
                Text(selection.wrappedValue.formattedHourMinute ?? "\(label) 시간 선택")
                    .foregroundStyle(selection.wrappedValue.hour == nil ? Color.grey500 : .grey900)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.grey100)
            )
            .contentShape(Rectangle())
        }
    }
    
    @ViewBuilder
    private func wheel(selection: Binding<Date>) -> some View {
        DatePicker("", selection: selection, displayedComponents: [.hourAndMinute])
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .onTapGesture {
                focusedField = config.id
            }
    }
    
    private func binding(for field: ExpandedField) -> Binding<Date> {
        Binding<Date>(
            get: {
                Calendar.current.date(from: field == .startAt ? selectedTimeRange.startAt : selectedTimeRange.endAt) ?? Date()
            },
            set: { newDate in
                let comps = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                if field == .startAt {
                    selectedTimeRange.startAt = comps
                } else {
                    selectedTimeRange.endAt = comps
                }
            }
        )
    }
}

#Preview {
    @Previewable @State var timeRange: TimeRange = .init(startAt: .init(hour: 9, minute: 0), endAt: .init(hour: 22, minute: 0))
    @FocusState var focusedField: String?
    
    TimeRangePickerComponentView(config: .init(id: "TimeRange", title: "운영시간"), selectedTimeRange: $timeRange, focusedField: $focusedField)
}
