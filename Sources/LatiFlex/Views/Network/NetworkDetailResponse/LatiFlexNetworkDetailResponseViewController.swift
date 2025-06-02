//
//  LatiFlexNetworkDetailResponseViewController.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexNetworkDetailResponseViewInterface: AnyObject, NavigationBarCustomButtonConfigurable {
    var boldAttr: [NSAttributedString.Key : Any] { get }
    
    func prepareUI()
    func setResponseView(text: String?)
    func setResponseView(attributedText: NSAttributedString?)
    func setResponseViewScrollToRange(nsRange: NSRange)
    func setResponseViewScrollToTop()
    func setToPasteboard(_ text: String)
    func showSuccessAlert(title: String, message: String)
    func showErrorAlert(title: String, message: String)
    func setSaveButtonEnabled(_ enabled: Bool)
    func showInvalidJsonIndicator()
    func hideInvalidJsonIndicator()
}

private extension LatiFlexNetworkDetailResponseViewController {
    enum Constant {
        static let responseViewFontSize: CGFloat = 12
        static let boldAttrFontSize: CGFloat = 16
    }
}

final class LatiFlexNetworkDetailResponseViewController: UIViewController {
    var presenter: LatiFlexNetworkDetailResponsePresenterInterface!
    
    private let responseView: UITextView = {
        let responseView = UITextView()
        responseView.font = .systemFont(ofSize: Constant.responseViewFontSize)
        responseView.isEditable = false
        return responseView
    }()
    
    private let searchBar = UISearchBar()
    private var saveButton: UIBarButtonItem!
    
    private let invalidJsonIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed.withAlphaComponent(0.1)
        view.isHidden = true
        return view
    }()
    
    private let invalidJsonLabel: UILabel = {
        let label = UILabel()
        label.text = "Invalid JSON Format"
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension LatiFlexNetworkDetailResponseViewController: LatiFlexNetworkDetailResponseViewInterface {
    var associatedNavigationItem: UINavigationItem { navigationItem }
    
    var boldAttr: [NSAttributedString.Key : Any] {
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constant.boldAttrFontSize, weight: .bold), .foregroundColor: UIColor.orange]
    }
    
    func prepareUI() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        view.addSubview(responseView)
        responseView.translatesAutoresizingMaskIntoConstraints = false
        
        // Mock durumuna göre Save butonu ve JSON validation ekle
        if LatiFlexNetworkInterceptor.shared.isMockingEnabled() {
            responseView.isEditable = true
            
            let saveBarButton = UIBarButtonItem(title: "Save",
                                              style: .plain,
                                              target: self,
                                              action: #selector(saveButtonTapped))
            saveBarButton.isEnabled = false
            saveButton = saveBarButton
            navigationItem.rightBarButtonItems = [saveBarButton]
            
            // Setup invalid JSON indicator
            view.addSubview(invalidJsonIndicator)
            invalidJsonIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            invalidJsonIndicator.addSubview(invalidJsonLabel)
            invalidJsonLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                invalidJsonIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                invalidJsonIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                invalidJsonIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                invalidJsonIndicator.heightAnchor.constraint(equalToConstant: 20),
                
                invalidJsonLabel.centerYAnchor.constraint(equalTo: invalidJsonIndicator.centerYAnchor),
                invalidJsonLabel.leadingAnchor.constraint(equalTo: invalidJsonIndicator.leadingAnchor, constant: 16),
                
                responseView.topAnchor.constraint(equalTo: invalidJsonIndicator.bottomAnchor),
                responseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                responseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                responseView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                responseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                responseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                responseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                responseView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        responseView.delegate = self
    }
    
    func setResponseView(text: String?) {
        responseView.text = text
    }
    
    func setResponseView(attributedText: NSAttributedString?) {
        responseView.attributedText = attributedText
    }
    
    func setResponseViewScrollToTop() {
        responseView.scrollToTop(animated: true)
    }
    
    func setResponseViewScrollToRange(nsRange: NSRange) {
        responseView.scrollRangeToVisible(nsRange)
    }
    
    func setToPasteboard(_ text: String) { UIPasteboard.general.string = text }
    
    func showSuccessAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, 
                                    message: message, 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, 
                                    message: message, 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func setSaveButtonEnabled(_ enabled: Bool) {
        saveButton?.isEnabled = enabled
    }
    
    func showInvalidJsonIndicator() {
        invalidJsonIndicator.isHidden = false
        invalidJsonLabel.isHidden = false
    }
    
    func hideInvalidJsonIndicator() {
        invalidJsonIndicator.isHidden = true
        invalidJsonLabel.isHidden = true
    }
    
    @objc private func saveButtonTapped() {
        presenter.saveButtonTapped(with: responseView.text)
    }
}

extension LatiFlexNetworkDetailResponseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.textDidChange(searchtext: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarSearchButtonClicked()
    }
}

extension LatiFlexNetworkDetailResponseViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.responseTextDidChange(textView.text)
    }
}

private extension UIScrollView {
    func scrollToTop(animated: Bool) {
        let newContentOffset = CGPoint(x: contentOffset.x, y: -contentInset.top)
        setContentOffset(newContentOffset, animated: animated)
    }
}
