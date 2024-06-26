//
//  ViewController.swift
//  WisdomLeafTask
//
//  Created by Sai Balaji on 25/06/24.
//

import UIKit
import Combine
import SDWebImage

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var vm = ImagesViewModel()
    var imagesAPISubscriber: AnyCancellable?
    var errorSubscriber: AnyCancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureUI()
        self.setupBinding()
    }
    
    
    func configureUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(UINib(nibName: "ImageCell", bundle: nil),forCellReuseIdentifier: "CELL")
        vm.getImages(pageCount: vm.currentPage)
    }
    
    func setupBinding(){
        imagesAPISubscriber = vm.$images.sink(receiveValue: { images  in
            DispatchQueue.main.async {
                print(images)
                self.tableView.reloadData()
            }
            
        })
        errorSubscriber = vm.$error.sink(receiveValue: { error  in
            DispatchQueue.main.async {
                if let error{
                    print(error)
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        })
    }
    
    
    func showAlert(title: String,message: String){
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(avc, animated: true)
    }
    
    
}


extension ImagesViewController: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if let lastIndexPath = indexPaths.last, vm.isLoading == false && lastIndexPath.row == vm.images.count - 1{
            vm.currentPage += 1
            
            vm.getImages(pageCount:vm.currentPage)
            
            print("CALLED PREFETCH AT \(lastIndexPath.row) \(vm.images.count)")
        }
        let urls = indexPaths.compactMap { indexPath -> URL? in
            let imageUrlString = vm.images[indexPath.row].downloadURL ?? ""
            return URL(string: imageUrlString)
        }
        
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        
        SDWebImagePrefetcher.shared.cancelPrefetching()
    }
}

extension ImagesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.images.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? ImageCell{
            cell.cellIndex = indexPath
            cell.delegate = self
            cell.updateCell(imageData: vm.images[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vm.images[indexPath.row].isChecked{
            self.showAlert(title: "Info", message: vm.images[indexPath.row].downloadURL ?? "")
        }
        else{
            self.showAlert(title: "Info", message: "Check box is disabled")
        }
    }
    
}


extension ImagesViewController: ImageCellDelegate{
    func checkBoxPressed(isChecked: Bool, index: IndexPath) {
        print("Check box of row \(index.row) is \(isChecked)")
        vm.images[index.row].isChecked = isChecked
        self.tableView.reloadRows(at: [index], with: .automatic)
    }
}
