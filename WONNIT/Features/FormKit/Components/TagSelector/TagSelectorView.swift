//
//  TagSelectorView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import SwiftUI
import UIKit

protocol TagSelectorViewDelegate: AnyObject {
    func tagsDidChange(to tags: [String])
    func didBeginEditing()
    func didEndEditing()
}

class TagSelectorView: UIControl {
    weak var delegate: AnyObject?
    
    var tags: [String] = []
    
    var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    var font: UIFont? {
        get { textField.font }
        set {
            textField.font = newValue
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            textField.tintColor = tintColor
        }
    }
    
    private let collectionView: UICollectionView
    private let textField = UITextField()
    private var previousTextFieldText: String?
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        setupViews()
        setupDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        collectionView.backgroundColor = .clear
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: "TextFieldCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
    
    @objc private func handleTap() {
        _ = becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var isEditing: Bool {
        return textField.isFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        (delegate as? TagSelectorViewDelegate)?.didBeginEditing()
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        let result = textField.resignFirstResponder()
        if result {
            (delegate as? TagSelectorViewDelegate)?.didEndEditing()
        }
        return result
    }
    
    override var inputAccessoryView: UIView? {
        get { return textField.inputAccessoryView }
        set { textField.inputAccessoryView = newValue }
    }
    
    func finalizeEditing() {
        if let text = textField.text, !text.isEmpty {
            addTag(from: text)
            textField.text = ""
        }
    }
    
    private func addTag(from string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && !tags.contains(trimmed) {
            let insertionIndex = tags.count
            tags.append(trimmed)
            collectionView.insertItems(at: [IndexPath(item: insertionIndex, section: 0)])
            scrollToEnd()
            sendActions(for: .valueChanged)
            (delegate as? TagSelectorViewDelegate)?.tagsDidChange(to: tags)
        }
    }
    
    private func scrollToEnd() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.tags.count, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
}

extension TagSelectorView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < tags.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
            let tag = tags[indexPath.item]
            cell.configure(with: tag)
            cell.onDelete = { [weak self] in
                guard let self = self else { return }
                if let index = self.tags.firstIndex(of: tag) {
                    self.tags.remove(at: index)
                    self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                    self.sendActions(for: .valueChanged)
                    (self.delegate as? TagSelectorViewDelegate)?.tagsDidChange(to: self.tags)
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.embed(textField: textField)
            return cell
        }
    }
}

extension TagSelectorView: UITextFieldDelegate {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.hasSuffix(" ") || text.hasSuffix(",") {
            let tagText = String(text.dropLast())
            addTag(from: tagText)
            textField.text = ""
        }
        previousTextFieldText = text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            addTag(from: text)
        }
        textField.text = ""
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (delegate as? TagSelectorViewDelegate)?.didBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (delegate as? TagSelectorViewDelegate)?.didEndEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty, range.length == 0, (textField.text ?? "").isEmpty, !tags.isEmpty {
            let lastIndex = tags.count - 1
            tags.removeLast()
            collectionView.deleteItems(at: [IndexPath(item: lastIndex, section: 0)])
            sendActions(for: .valueChanged)
            (delegate as? TagSelectorViewDelegate)?.tagsDidChange(to: tags)
            return false
        }
        return true
    }
}

class TagCell: UICollectionViewCell {
    var onDelete: (() -> Void)?
    
    private let tagLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(Color.primaryPurple100)
        contentView.layer.cornerRadius = 4
        
        tagLabel.font = .systemFont(ofSize: 14, weight: .medium)
        tagLabel.textColor = UIColor(Color.primaryPurple)
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .bold)
        deleteButton.setImage(UIImage(systemName: "xmark", withConfiguration: symbolConfig), for: .normal)
        deleteButton.tintColor = UIColor(Color.primaryPurple)
        deleteButton.backgroundColor = .white
        deleteButton.layer.cornerRadius = 8
        deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [tagLabel, deleteButton])
        stackView.spacing = 4
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.5),
            deleteButton.widthAnchor.constraint(equalToConstant: 16),
            deleteButton.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func configure(with tag: String) {
        tagLabel.text = tag
    }
    
    @objc private func handleDelete() {
        onDelete?()
    }
}

class TextFieldCell: UICollectionViewCell {
    private var textField: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func embed(textField: UITextField) {
        if self.textField === textField { return }
        self.textField?.removeFromSuperview()
        self.textField = textField
        
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
}
