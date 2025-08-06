//
//  DashboardView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct DashboardView: View {
    @State var dashboardNavigationManager = NavigationManager()
    @Environment(TabShouldResetManager.self) private var tabShouldResetManager
    
    @State private var spacesToShow: [Space] = Space.mockList
    @State private var isEditMode: Bool = false
    @State private var selectedSpaceIDs: Set<UUID> = []
    
    var body: some View {
        NavigationStack(path: $dashboardNavigationManager.path) {
            ZStack(alignment: .bottomLeading) {
                ScrollViewReader { proxy in
                    ScrollView {
                        Color.clear
                            .frame(height: 0)
                            .id("topAnchor")
                        
                        VStack(alignment: .leading, spacing: 20) {
                            if isEditMode {
                                Button {
                                    toggleSelectAll()
                                } label: {
                                    HStack(spacing: 6) {
                                        SelectionIndicatorView(isSelected: selectedSpaceIDs.count == spacesToShow.count)
                                        Text("전체선택(\(selectedSpaceIDs.count)/\(spacesToShow.count))")
                                            .body_04(.grey700)
                                    }
                                }
                                .buttonStyle(.plain)
                            } else {
                                Text("등록 공간 \(spacesToShow.count)개")
                                    .body_04(.grey700)
                            }
                            
                            if spacesToShow.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "tray")
                                        .font(.system(size: 44))
                                        .foregroundColor(.gray.opacity(0.5))
                                        .transition(.scale)
                                    Text("등록된 공간이 없습니다.")
                                        .body_04(.grey500)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 80)
                            } else {
                                LazyVStack(spacing: 20) {
                                    ForEach(spacesToShow) { space in
                                        if isEditMode {
                                            SelectableCardView(
                                                space: space,
                                                isSelected: selectedSpaceIDs.contains(space.id),
                                                onToggle: { toggleSelection(for: space.id) }
                                            )
                                        } else {
                                            NavigationLink(value: Route.spaceDetailByModel(space: space)) {
                                                SpacePreviewCardView(
                                                    space: space,
                                                    layout: .horizontal(height: 123),
                                                    pricePosition: .leading
                                                )
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .paddedForTabBar()
                    }
                    .onChange(of: tabShouldResetManager.resetTriggers[.dashboard]) {
                        handleTabReselect(proxy: proxy)
                    }
                }
                
                if isEditMode && !selectedSpaceIDs.isEmpty {
                    deleteButton
                        .padding(.bottom, 12)
                }
            }
            .navigationTitle("내가 등록한 공간")
            .navigationBarTitleDisplayMode(.large)
            //            .withBackButtonToolbar()
            .navigationBarBackButtonHidden()
            .toolbarBackground(Color.white)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: toggleEditMode) {
                        Text(isEditMode ? "완료" : "편집")
                            .body_04(.grey900)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .spaceListByCategory(let category):
                    SpaceListView(category: category)
                case .spaceListByRecent:
                    SpaceListView(category: nil)
                case .spaceDetailById(let spaceId):
                    Text("\(spaceId)")
                case .spaceDetailByModel(let space):
                    SpaceDetailView(space: space)
                        .padding(.horizontal)
                        .padding(.bottom, -40)
                        .frame(maxWidth: .infinity)
                        .withBackButtonToolbar()
                }
            }
        }
    }
    
    private func toggleSelection(for id: UUID) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            if selectedSpaceIDs.contains(id) {
                selectedSpaceIDs.remove(id)
            } else {
                selectedSpaceIDs.insert(id)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
    
    private func toggleEditMode() {
        withAnimation(.easeInOut) {
            isEditMode.toggle()
            if !isEditMode {
                selectedSpaceIDs.removeAll()
            }
        }
    }
    
    private func deleteSelectedSpaces() {
        withAnimation(.easeInOut) {
            spacesToShow.removeAll { selectedSpaceIDs.contains($0.id) }
            selectedSpaceIDs.removeAll()
            if spacesToShow.isEmpty {
                isEditMode = false
            }
        }
    }
    
    private var deleteButton: some View {
        Button(action: deleteSelectedSpaces) {
            Image(systemName: "trash")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .clipShape(Circle())
        }
        .padding()
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
    
    private func toggleSelectAll() {
        withAnimation {
            if selectedSpaceIDs.count == spacesToShow.count {
                selectedSpaceIDs.removeAll()
            } else {
                selectedSpaceIDs = Set(spacesToShow.map(\.id))
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    private func handleTabReselect(proxy: ScrollViewProxy) {
        if !dashboardNavigationManager.path.isEmpty {
            dashboardNavigationManager.path = NavigationPath()
        } else {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo("topAnchor", anchor: .top)
            }
        }
    }
}

struct SelectableCardView: View {
    let space: Space
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            SpacePreviewCardView(
                space: space,
                layout: .horizontal(height: 123),
                pricePosition: .leading
            )
            
            SelectionIndicatorView(isSelected: isSelected)
                .padding(10)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle()
        }
    }
}

struct SelectionIndicatorView: View {
    let isSelected: Bool
    
    var body: some View {
        Image(systemName: "checkmark.square.fill")
            .resizable()
            .frame(width: 18, height: 18)
            .foregroundColor(isSelected ? Color.primaryPurple : .grey200)
            .accessibilityIdentifier(isSelected ? "선택됨" : "선택 안됨")
    }
}
