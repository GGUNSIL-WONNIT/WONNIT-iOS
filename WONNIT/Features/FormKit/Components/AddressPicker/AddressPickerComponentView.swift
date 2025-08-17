//
//  AddressPickerComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/17/25.
//

import SwiftUI
import CoreLocation

struct AddressPickerComponentView: View {
    let config: FormFieldBaseConfig
    @Environment(FormStateStore.self) private var store
    
    private var address: Binding<KakaoAddress?> {
        store.addressBinding(for: config.id)
    }
    
    private var coordinates: Binding<CLLocationCoordinate2D?> {
        store.coordinatesBinding(for: config.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = config.title { Text(title).body_02(.grey900) }
            
            GeoSearchView(address: address, coordinates: coordinates)
        }
    }
}
