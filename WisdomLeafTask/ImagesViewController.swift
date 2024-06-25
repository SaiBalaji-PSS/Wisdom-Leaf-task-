//
//  ViewController.swift
//  WisdomLeafTask
//
//  Created by Sai Balaji on 25/06/24.
//

import UIKit
import Combine

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
                }
            }
        })
    }
    

}



extension ImagesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.images.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? ImageCell{
            cell.titleLbl.text = vm.images[indexPath.row].author ?? ""
            cell.descriptionLbl.text = (vm.images[indexPath.row].downloadURL ?? "") + (vm.images[indexPath.row].downloadURL ?? "") + (vm.images[indexPath.row].downloadURL ?? "")
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if vm.isLoading == false && indexPath.row == vm.images.count - 2{
            vm.currentPage += 1
            vm.getImages(pageCount:vm.currentPage)
        }
    }
}
