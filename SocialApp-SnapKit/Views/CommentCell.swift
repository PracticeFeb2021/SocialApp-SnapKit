//
//  CommentCell.swift
//  CommentCell
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit
import SnapKit

class CommentCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    static let cellReuseId = "CommentCell"
    
    let spacing: CGFloat = 10
    let titleSpacing: CGFloat = 50

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(spacing)
            make.leading.equalTo(contentView).offset(titleSpacing)
            make.trailing.equalTo(contentView).offset(-1 * titleSpacing)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacing)
            make.leading.equalTo(contentView).offset(spacing)
            make.trailing.equalTo(contentView).offset(-1 * spacing)
            make.bottom.equalTo(contentView).offset(-1 * spacing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: Comment) {
        titleLabel.text = comment.name
        bodyLabel.text = comment.body
    }
}

