//
//  TopAlbumTableViewCell.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

class TopAlbumTableViewCell: UITableViewCell {
    
    let albumImageView = UIImageView()
    let containerView = UIView()
    let stackView = UIStackView()
    let albumLabel = UILabel()
    let artistNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        albumImageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        albumImageView.contentMode = .scaleToFill
        stackView.axis = .vertical
        stackView.addArrangedSubview(albumLabel)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        [albumImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        let albumHeight = albumImageView.heightAnchor.constraint(equalToConstant: 100)
        albumHeight.priority = .defaultLow
        NSLayoutConstraint.activate([
            // Container View
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            // ImageView
            albumImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            albumImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 100),
            albumHeight,
            
            // Stack
            stackView.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10)
        ])
    }
}
