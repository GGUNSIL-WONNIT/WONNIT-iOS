//
//  EditSpaceFormStepComponents.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import Foundation

extension EditSpaceFormStep {
    var components: [FormComponent] {
        switch self {
        case .pictures:
            return [
                .imageUploader(
                    config: .init(
                        id: "mainImage",
                        title: "대표사진"
                    ),
                    variant: .singleLarge
                ),
                .imageUploader(
                    config: .init(
                        id: "subImages",
                        title: "추가사진"
                    ),
                    variant: .multipleSmall(limit: 5)
                )
            ]
        case .details:
            return [
                .textField(config: .init(
                    id: "address1",
                    title: "주소",
                    placeholder: "주소를 입력해주세요"
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
                .select(
                    config: .init(
                        id: "category",
                        title: "공간 카테고리",
                        placeholder: "카테고리를 선택하세요"
                    ),
                    options: SpaceCategory.allCases.map(\.label)
                ),
                .doubleField(config: .init(
                    id: "area",
                    title: "공간 크기",
                    placeholder: "공간 크기를 입력해주세요 / 예) 12.25",
                    suffix: "m²",
                    keyboardType: .decimalPad
                )),
                .tagSelector(config: .init(
                    id: "spaceTags",
                    title: "태그",
                    placeholder: "공간 태그를 입력해주세요"
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
            
        case .miscellaneous:
            return [
                .textField(config: .init(
                    id: "contact",
                    title: "담당자 연락처",
                    placeholder: "연락처를 입력해주세요",
                    keyboardType: .phonePad
                )),
                .textField(config: .init(
                    id: "cautions",
                    title: "기타 주의사항(선택)",
                    placeholder: "주의사항이 있다면 입력해주세요"
                ))
            ]
            
        case .roomScan:
            return [
                .scannerView(id: "roomScan")
            ]
        }
    }
}
