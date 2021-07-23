//
//  NewPostVC.swift
//  SocialApp-MVC
//
//  Created by Oleksandr Bretsko on 22.07.2021.
//

import UIKit
import SnapKit

class NewPostVC: UIViewController {
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        return line
    }()
    
    let postTitleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .boldSystemFont(ofSize: 24)
        textField.placeholder = "Enter title"
        return textField
    }()
    
    let postBodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        return textView
    }()
    
    var netService: NetworkingService!
    
    enum Mode {
        case new
        case edit
    }
    var mode: Mode = .new
    
    var post: Post?
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [topLabel, lineView, postTitleTextField, postBodyTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(topLabel)
        view.addSubview(lineView)
        view.addSubview(postTitleTextField)
        view.addSubview(postBodyTextView)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(view)
        }
        
        postTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(postTitleTextField.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        postBodyTextView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        switch mode {
        case .new:
            topLabel.text = "New post"
        case .edit:
            topLabel.text = ""
        }
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
        
        if let post = post {
            postTitleTextField.text = post.title
            postBodyTextView.text = post.body
        }
    }
    
    //MARK: - Methods
    
    @objc func doneButtonPressed() {
        switch mode {
        case .new:
            guard validateCurrentPost() else {
                presentAlert()
                return
            }
        //TODO: create post
        case .edit:
            guard validateCurrentPost() else {
                presentAlert()
                return
            }
            var editedPost = post!
            editedPost.title = postTitleTextField.text!
            editedPost.body = postBodyTextView.text!
        //TODO: update post
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "Post title and body cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func validateCurrentPost() -> Bool {
        guard let postTitle = postTitleTextField.text, !postTitle.isEmpty,
              let postBody = postBodyTextView.text,
              !postBody.isEmpty else {
            return false
        }
        return true
    }
}
