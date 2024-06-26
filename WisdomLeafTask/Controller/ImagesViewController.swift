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
    
    //MARK: - PROPERTIES
    @IBOutlet weak var tableView: UITableView!
    var vm = ImagesViewModel()
    var imagesAPISubscriber: AnyCancellable?
    var errorSubscriber: AnyCancellable?
    
    //MARK: - LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureUI()
        self.setupBinding()
    }
    
 
    
    
    //MARK: - CONFIGURE UITABLE VIEW AND NAVIGATION BAR RIGHT BAR BUTTON ITEM
    func configureUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(UINib(nibName: "ImageCell", bundle: nil),forCellReuseIdentifier: "CELL")
       

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        vm.getImages(pageCount: vm.currentPage)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(refreshBtnPressed))
        
    }
    //MARK: - CLEAR THE ARRAY AND FETCH THE UPDATED DATA FROM API
    @objc func refreshBtnPressed(){
        vm.images.removeAll()
        self.tableView.reloadData()
        vm.getImages(pageCount: 1)
    }
    
    //MARK: - SETUP MVVM BINDING WITH THE VIEW-MODEL
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
    
    
    //MARK: - SHOW NATIVE ALERT FOR GIVEN TITLE AND MESSAGE
    func showAlert(title: String,message: String){
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(avc, animated: true)
    }
    
    
}

//MARK: - FOR PREFETCHING DATA FROM API
extension ImagesViewController: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if let lastIndexPath = indexPaths.last, vm.isLoading == false && lastIndexPath.row == vm.images.count - 1{
            vm.currentPage += 1
            
            vm.getImages(pageCount:vm.currentPage)
            
            print("CALLED PREFETCH AT \(lastIndexPath.row) \(vm.images.count)")
        }
       
        
    }
    
  
}

//MARK: - TABLE VIEW DELEGATE METHODS
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
  
   
    
    
}



//MARK: - DELEGATE METHOD WHEN THE CHECK BOX IN TABLE VIEW CELL IS PRESSED

extension ImagesViewController: ImageCellDelegate{
    func checkBoxPressed(isChecked: Bool, index: IndexPath) {
        //print("Check box of row \(index.row) is \(isChecked)")
        vm.images[index.row].isChecked = isChecked
        self.tableView.reloadData()
    }
}
