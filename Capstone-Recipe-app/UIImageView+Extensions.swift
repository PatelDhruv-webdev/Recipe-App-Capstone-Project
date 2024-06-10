import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
