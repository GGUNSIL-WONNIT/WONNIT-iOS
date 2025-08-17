//
//  GeoSearchView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/17/25.
//

import SwiftUI
import CoreLocation
import MapKit
import Moya

struct GeoSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    private let kakaoAPIProvider = MoyaProvider<KakaoAPI>()
    
    @Binding var address: KakaoAddress?
    @Binding var coordinates: CLLocationCoordinate2D?
    
    @State private var showAddressPicker = false
    @State private var isLoading: Bool = false
    
    private let hostedAddressPageURL = URL(string: "https://ggungsil-wonnit.github.io/WONNIT-GeoService-Web/")!
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let address {
                Button {
                    showAddressPicker = true
                } label: {
                    HStack(spacing: 6) {
                        Text(address.roadAddress)
                            .foregroundStyle(Color.grey900)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.grey100, lineWidth: 1)
                    )
                    .contentShape(Rectangle())
                }
                
                if let coordinates {
                    SpaceDetailMiniMapView(spaceCoordinates: coordinates)
                        .padding(.horizontal, 4)
                }
            } else {
                Button {
                    showAddressPicker = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .light))
                            .foregroundStyle(Color(UIColor.secondaryLabel))
                        
                        Text("주소 검색하기")
                            .foregroundStyle(Color(UIColor.secondaryLabel))
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.grey100, lineWidth: 1)
                    )
                    .contentShape(Rectangle())
                }
            }
        }
        .sheet(isPresented: $showAddressPicker) {
            VStack(spacing: 4) {
                topBar
                
                KakaoAddressWebView(pageURL: hostedAddressPageURL) { addr in
                    address = addr
                    getCoordinates(for: addr.roadAddress)
                    
                    showAddressPicker = false
                }
                .ignoresSafeArea()
            }
        }
    }
    
    @ViewBuilder
    private var topBar: some View {
        ZStack {
            Text("주소 검색")
                .body_03(.grey900)
            HStack {
                backButton
                Spacer()
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    private var backButton: some View {
        Button {
            showAddressPicker = false
        } label: {
            Text("취소")
                .body_04(.grey900)
        }
        .foregroundStyle(Color.grey900)
        .font(.system(size: 18))
    }
    
    private func getCoordinates(for address: String) {
        isLoading = true
        coordinates = nil
        
        kakaoAPIProvider.request(.geocode(query: address)) { result in
            isLoading = false
            switch result {
            case .success(let response):
                do {
                    let geocodeResponse = try JSONDecoder().decode(KakaoGeocodeResponse.self, from: response.data)
                    if let coordinate = geocodeResponse.documents.first?.coordinate {
                        self.coordinates = coordinate
                    } else {
                        print("주소에 해당하는 좌표를 찾을 수 없습니다.")
                    }
                } catch {
                    print("디코딩 실패: \(error)")
                }
            case .failure(let error):
                print("API 호출 실패: \(error)")
            }
        }
    }
}
