//
//  CreateSpaceFormStep.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

enum CreateSpaceFormStep: FormStep {
    case addressAndName
    case pictures
    case categoryAndTags
    case operation
    case scanner
    case miscellaneous
    
    var sectionTitle: String? {
        switch self {
        case .addressAndName:
            return "공간 주소와 이름 정보를\n입력해주세요"
        case .pictures:
            return "공간 사진과 기본정보를\n등록해주세요"
        case .categoryAndTags:
            return "공간 카테고리와 구비물품을\n확인해주세요"
        case .operation:
            return "공간 대여 정보 및\n금액을 입력해주세요"
        case .scanner:
            return "3D 스캔 정보를\n등록해주세요(선택)"
        case .miscellaneous:
            return "기타 정보를 등록해주세요"
        }
    }
    
    var isOptional: Bool {
        switch self {
        case .scanner:
            return true
        default:
            return false
        }
    }
    
    var components: [FormComponent] {
        switch self {
        case .addressAndName:
            return [
                .addressPicker(config: .init(
                    id: "address1",
                    title: "주소"
                )),
                .textField(config: .init(
                    id: "address2",
                    title: "상세주소",
                    placeholder: "상세주소를 입력해주세요"
                )),
                .textField(config: .init(
                    id: "name",
                    title: "공간이름",
                    placeholder: "공간 이름을 입력해주세요 / 예) 노원 힐링스페이스"
                )),
                .doubleField(
                    config: .init(
                        id: "area",
                        title: "공간 크기",
                        placeholder: "공간 크기를 입력해주세요 / 예) 12.25",
                        suffix: "m²",
                        keyboardType: .decimalPad
                    )
                )
            ]

        case .pictures:
            return [
                .imageUploaderWithML(
                    config: .init(
                        id: "mainImage",
                        title: "대표사진 등록",
                        spaceCategoryFormComponentKey: "category",
                        spaceTagFormComponentKey: "tags"
                    ),
                    variant: .singleLarge
                ),
                .imageUploaderWithML(
                    config: .init(
                        id: "subImages",
                        title: "추가사진 등록",
                        spaceTagFormComponentKey: "tags"
                    ),
                    variant: .multipleSmall(limit: 4)
                )
            ]
            
        case .categoryAndTags:
            return [
                .select(
                    config: .init(
                        id: "category",
                        title: "공간 카테고리",
                        placeholder: "카테고리를 선택하세요",
                        isAIFeatured: true
                    ),
                    options: SpaceCategory.allCases.map(\.label)
                ),
                .tagSelector(config: .init(
                    id: "tags",
                    title: "구비물품",
                    isAIFeatured: true,
                    spaceCategoryFormComponentKey: "category"
                ))
            ]

        case .operation:
            return [
                .dayPicker(config: .init(
                    id: "openDay",
                    title: "운영요일"
                )),
                .timeRangePicker(config: .init(
                    id: "openTime",
                    title: "운영시간"
                )),
                .pricingField(config: .init(
                    id: "pricing",
                    title: "금액정보"
                ))
            ]

        case .scanner:
            return [
                .roomScanner(config: .init(
                    id: "roomScanner",
                ))
            ]

        case .miscellaneous:
            return [
                .phoneNumberField(config: .init(
                    id: "contact",
                    title: "담당자 연락처",
                    placeholder: "연락처를 입력해주세요",
                )),
                .optionalTextField(config: .init(
                    id: "cautions",
                    title: "기타 주의사항(선택)",
                    placeholder: "주의사항이 있다면 입력해주세요"
                ))
            ]
        }
    }
    
    var hideDefaultButton: Bool {
        switch self {
        default:
            return false
        }
    }
}
