//
//  ErrorMessageView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ErrorMessageView: View {
    let title: String
    let message: String
    var collapsedLines: Int = 2
    var maxExpandedHeight: CGFloat = 120
    
    @State private var expanded = false
    @State private var copied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.callout)
                    .foregroundStyle(Color.grey900)
                
                Text(title)
                    .body_03(.grey900)
                
                Spacer()
                
                Button {
                    withAnimation {
                        expanded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(expanded ? 90 : 0))
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    expanded.toggle()
                }
            }
            
            Divider()
            
            Group {
                if expanded {
                    ScrollView {
                        Text(message)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
                    .frame(maxHeight: maxExpandedHeight)
                } else {
                    Text(message)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(collapsedLines)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.top, 4)
            .contextMenu {
                Button {
                    UIPasteboard.general.setValue(message, forPasteboardType: UTType.plainText.identifier)
                    withAnimation { copied = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation { copied = false }
                    }
                } label: {
                    Label(copied ? "복사완료" : "복사하기", systemImage: copied ? "checkmark.circle" : "doc.on.doc")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
    }
}

extension ErrorMessageView {
    init(title: String = "오류", error: Error, collapsedLines: Int = 2, maxExpandedHeight: CGFloat = 220) {
        self.init(title: title, message: error.localizedDescription, collapsedLines: collapsedLines, maxExpandedHeight: maxExpandedHeight)
    }
}

#Preview {
    ErrorMessageView(
        title: "공간을 불러올 수 없습니다.",
        message:
            """
            Client encountered an error invoking the operation "getRecentSpaces".
            Underlying error: ATS requires HTTPS.
            URL: http://43.201.251.218:8080/api/v1/recent-spaces
            Suggestion: Use HTTPS or a Debug-only ATS exception.
            """
    )
    .padding()
}
