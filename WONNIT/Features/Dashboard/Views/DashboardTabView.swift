//
//  DashboardTabView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct DashboardTabView<Selection>: View where Selection: Identifiable & Hashable & Comparable & TabLabelConvertible {
    @Environment(AppSettings.self) private var appSettings
    
    var views: [Selection: AnyView]
    
    @Binding var selection: Selection
    @Namespace private var namespace
    
    private var sortedKeys: [Selection] {
        views.keys.sorted()
    }
    
    private var selectedIndex: Int {
        sortedKeys.firstIndex(of: selection) ?? 0
    }
    
    public init(
        views: [Selection: AnyView],
        selection: Binding<Selection>
    ) {
        self.views = views
        self._selection = selection
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Menu {
                ForEach(Array(TestUser.allCases.enumerated()), id: \.offset) { index, user in
                    Button {
                        appSettings.selectedTestUserID = user.rawValue
                    } label: {
                        Label("User \(index + 1)", systemImage: appSettings.selectedTestUserID == user.rawValue ? "person.fill.checkmark" : "person.fill")
                    }
                }
            } label : {
                Text("마이페이지")
                    .body_03(.grey900)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
            }
            
            tabBar
            
            TabView(selection: $selection) {
                ForEach(sortedKeys) { key in
                    if let view = views[key] {
                        view.tag(key)
                    } else {
                        Color.clear.tag(key)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(sortedKeys) { key in
                tabButton(for: key)
            }
        }
        .overlay(alignment: .bottomLeading) {
            GeometryReader { proxy in
                let count = max(1, sortedKeys.count)
                let tabWidth = proxy.size.width / CGFloat(count)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.grey300)
                        .frame(height: 3)
                    
                    Rectangle()
                        .fill(Color.primaryPurple)
                        .frame(width: tabWidth, height: 3)
                        .offset(x: CGFloat(selectedIndex) * tabWidth)
                        .animation(.spring(response: 0.28, dampingFraction: 0.85), value: selectedIndex)
                }
            }
            .frame(height: 3)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selection)
    }

    private func tabButton(for key: Selection) -> some View {
        Button {
            selection = key
        } label: {
            VStack(spacing: 9) {
                Text(key.label)
                    .body_03(selection == key ? Color.primaryPurple : .grey300)
                    .frame(maxWidth: .infinity)
                Color.clear.frame(height: 3)
            }
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}
