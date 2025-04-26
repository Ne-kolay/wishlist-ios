import UIKit

class WishlistDetailsViewController: UIViewController {
    
    var wishlist: WishlistDTO?
    private var gifts: [GiftDTO] = []
    
    private let descriptionLabel = UILabel()
    private let privacyLabel = UILabel()
    
    private let layout = UICollectionViewFlowLayout()
    
    private lazy var giftsCollectionView: UICollectionView = {
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GiftCell.self, forCellWithReuseIdentifier: "GiftCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if let wishlist = wishlist {
            title = wishlist.name
        }

        setupUI()
        displayWishlist()
        fetchGifts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let spacing: CGFloat = 10
        let totalSpacing = spacing + spacing + spacing
        let itemWidth = (view.bounds.width - totalSpacing - 20 - 20) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.7)
    }

    private func setupUI() {
        descriptionLabel.font = .systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray

        privacyLabel.font = .systemFont(ofSize: 14)
        privacyLabel.textColor = .secondaryLabel
        privacyLabel.numberOfLines = 1

        let infoStackView = UIStackView(arrangedSubviews: [descriptionLabel, privacyLabel])
        infoStackView.axis = .vertical
        infoStackView.spacing = 6
        infoStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(infoStackView)
        view.addSubview(giftsCollectionView)

        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            giftsCollectionView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 20),
            giftsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            giftsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            giftsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func displayWishlist() {
        guard let wishlist = wishlist else { return }
        descriptionLabel.text = wishlist.description
        privacyLabel.text = "Приватность: \(wishlist.privacyLevel)"
    }

    // MARK: - Fetch Gifts
    private func fetchGifts() {
        guard let wishlistId = wishlist?.id else { return }
        
        let urlString = "http://192.168.3.26:8080/wishlists/\(wishlistId)/gifts"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching gifts: \(error)")
                return
            }
            guard let data = data else { return }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            do {
                let gifts = try JSONDecoder().decode([GiftDTO].self, from: data)
                DispatchQueue.main.async {
                    self?.gifts = gifts
                    self?.giftsCollectionView.reloadData()
                }
            } catch {
                print("Error decoding gifts: \(error)")
            }
        }

        task.resume()
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension WishlistDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCell", for: indexPath) as! GiftCell
        let gift = gifts[indexPath.item]
        cell.configure(with: gift)
        return cell
    }
}

// MARK: - GiftCell
class GiftCell: UICollectionViewCell {
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 14)
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center

        priceLabel.font = .systemFont(ofSize: 12)
        priceLabel.textAlignment = .center
        priceLabel.textColor = .systemGreen
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with gift: GiftDTO) {
        nameLabel.text = gift.name
        priceLabel.text = "Цена: \(gift.estimatedPrice)₽"
    }
}
