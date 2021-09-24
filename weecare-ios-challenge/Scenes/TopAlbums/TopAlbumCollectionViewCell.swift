//
//  TopAlbumCollectionViewCell.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

class TopAlbumCollectionViewCell: UICollectionViewCell {
    
    let albumImageView = UIImageView()
    let containerView = UIView()
    let stackView = UIStackView()
    let albumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        stackView.spacing = 2
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        [albumImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        
        let albumHeight = albumImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 2 / 3)
        albumHeight.priority = .defaultLow
        NSLayoutConstraint.activate([
            // Container View
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // ImageView
            albumImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            albumImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            albumHeight,
            
            // Stack
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 8),
        ])
    }
}
