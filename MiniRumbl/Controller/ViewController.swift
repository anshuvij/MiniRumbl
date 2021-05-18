//
//  ViewController.swift
//  MiniRumbl
//
//  Created by Anshu Vij on 15/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var videoURLData = VideoURLData()
    var videoData = [ModelData]()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Helpers
    private func setupUI() {
        
        self.navigationController?.navigationBar.isHidden = true
        tableView.register(UINib(nibName: Constants.videoTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.videoTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        videoURLData.delegate = self
        videoURLData.readLocalFile()
    }
    
    
}
//MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return videoData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return videoData[section].title
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font =  .boldSystemFont(ofSize: 18.0)
        header.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
}

//MARK: - UITableViewDataSource
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.videoTableViewCell) as! VideoTableViewCell
        cell.rowNumber = indexPath.section
        cell.sectionName = videoData[indexPath.section].title
        cell.sectionValue = videoData[indexPath.section].nodes
        cell.delegate = self
        return cell
    }
    
    
}

//MARK: - VideoTableViewCellDelegate
extension ViewController : VideoTableViewCellDelegate {
    
    func selectedDevice(category: String, value: String, index : Int, rowNumber : Int) {
       
        //print("category:\(category) - value:\(value) - index:\(index)  row:\(rowNumber)")
        
        let vc = VideoPlayerVC()
        vc.nodes = videoData[rowNumber].nodes
        vc.currentIndex = index
        vc.playUrl = value
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deSelectDevice(category: String, value: String) {
        
    }
    
}

//MARK: - VideoURLDataDelegate
extension ViewController : VideoURLDataDelegate {
    func getData(_ VideoURLData: VideoURLData, modelData: [ModelData]) {
        
        videoData = modelData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    
}

extension UIViewController {
  func alertNoInternet() {
    let alertController = UIAlertController(title: "No Internet!", message: "Please Check Internet Connectivity", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

