//
//  MatchedGeometry.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import Foundation
import SwiftUI

extension View {
    func matchedGeometry(id: String, in namespace: Namespace.ID?) -> some View {
        if let ns = namespace {
            return AnyView(self.matchedGeometryEffect(id: id, in: ns))
        } else {
            return AnyView(self)
        }
    }
}
