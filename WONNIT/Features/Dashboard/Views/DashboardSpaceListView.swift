//
//  DashboardSpaceListView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct DashboardSpaceListView: View {
    @Environment(\.navigationManager) private var nav
    
    let selectedDashboardTab: DashboardTab
    
    @Binding var spacesToShow: [Space]
    @State var selectedSpaceIDs: Set<UUID> = []
    @State var isEditMode: Bool = false
    @State private var showDeleteConfirmation = false
    
    @Namespace private var namespace
    
    var body: some View {
        ScrollView {
            Color.clear
                .frame(height: 0)
                .id("topAnchor")
            
            LazyVStack(alignment: .leading, spacing: 24) {
                dashboardTabHeaderView
                    .padding(.horizontal, 16)
                
                if spacesToShow.isEmpty {
                    NotFoundView(label: "아직 \(selectedDashboardTab.shortWord)한 공간이 없어요!")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 120)
                } else {
                    spaceList
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .paddedForTabBar()
        }
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottomLeading) {
            deleteButton
                .padding(.bottom, 6)
        }
    }
    
    private var dashboardTabHeaderView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                Text(selectedDashboardTab.label)
                    .title_01(.grey900)
                
                Spacer()
                
                if selectedDashboardTab.isEditable && !spacesToShow.isEmpty {
                    Button{
                        withAnimation {
                            isEditMode.toggle()
                            if !isEditMode {
                                selectedSpaceIDs.removeAll()
                            }
                        }
                    } label: {
                        Text(isEditMode ? "완료" :"편집")
                            .body_04(.grey700)
                    }
                }
            }
            
            if isEditMode {
                Button {
                    toggleSelectAll()
                } label: {
                    HStack(spacing: 6) {
                        SelectionIndicatorView(isSelected: selectedSpaceIDs.count == spacesToShow.count)
                        Text("전체선택(\(selectedSpaceIDs.count)/\(spacesToShow.count))")
                            .body_04(.grey700)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .matchedGeometry(id: "counterText", in: namespace)
                    }
                }
                .buttonStyle(.plain)
            } else {
                Text("\(selectedDashboardTab.shortWord) 공간 \(spacesToShow.count)개")
                    .body_04(.grey700)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .matchedGeometry(id: "counterText", in: namespace)
            }
        }
    }
    
    private var spaceList: some View {
        LazyVStack(spacing: 24) {
            ForEach(spacesToShow) { space in
                VStack(spacing: 12) {
                    let isSelected = selectedSpaceIDs.contains(space.id)
                    
                    ZStack(alignment: .topLeading) {
                        SpacePreviewCardView(
                            space: space,
                            layout: .horizontal(height: 123),
                            pricePosition: .leading
                        )
                        .opacity(isEditMode ? (isSelected ? 1 : 0.6) : 1)
                        
                        if isEditMode {
                            SelectionIndicatorView(isSelected: isSelected)
                                .padding(10)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isEditMode {
                            toggleSelection(for: space.id)
                        } else {
                            nav.push(Route.spaceDetailByModel(space: space))
                        }
                    }
                    
                    if selectedDashboardTab == .myRentedSpaces {
                        ReturnSpaceActionButtonView(spaceId: space.id)
                    }
                }
                .padding(.horizontal, 16)
                
                Divider()
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func toggleSelection(for id: UUID) {
        withAnimation {
            if selectedSpaceIDs.contains(id) {
                selectedSpaceIDs.remove(id)
            } else {
                selectedSpaceIDs.insert(id)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
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
    
    private func deleteSelectedSpaces() {
        withAnimation {
            spacesToShow.removeAll { selectedSpaceIDs.contains($0.id) }
            
            selectedSpaceIDs.removeAll()
            
            isEditMode = false
        }
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        let isVisible = isEditMode && !selectedSpaceIDs.isEmpty
        
        Button {
            showDeleteConfirmation = true
        } label: {
            Image(systemName: "trash")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .clipShape(Circle())
        }
        .padding()
        .offset(x: isVisible ? 0 : -80)
        .opacity(isVisible ? 1 : 0)
        .allowsHitTesting(isVisible)
        .accessibilityHidden(!isVisible)
        .alert("선택한 공간을 삭제하시겠어요?", isPresented: $showDeleteConfirmation) {
            Button("삭제", role: .destructive) {
                deleteSelectedSpaces()
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("\(selectedSpaceIDs.count)개의 공간이 삭제됩니다.")
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
