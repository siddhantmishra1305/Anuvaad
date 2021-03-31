//
//  LanguageViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import UIKit
import Foundation

class LanguageViewController: UIViewController {
    
    @IBOutlet weak var languageLBL: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var languageListView: UITableView!
    
    var sender : String!
    weak var delegate : LanguageSelection?
    let translatedVM = TranslationViewModel()
    var languages : Languages?
    var currentLanguage : Language!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageListView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        languages = translatedVM.getLanguages()?.filter({$0.language != currentLanguage.language})
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("LanguageViewController unintialized from memory")
    }
    
}

extension LanguageViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return languages!.count 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        cell.cellData = languages?[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? LanguageCell
        if let flag = cell?.flag.image, let language = languages?[indexPath.section]{
            dismiss(animated: true, completion: nil)
            delegate?.languageSelected(flag: flag, language:language,sender:sender)
        }
    }
    
}

extension LanguageViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0{
            languages = translatedVM.getLanguages()?.filter({$0.language != currentLanguage.language})
            languageListView.reloadData()
        }
        
        if searchText.count > 0 {
            languages = languages?.filter({
                ($0.name?.contains(searchText) ?? false)
            })
            languageListView.reloadData()
        }
        
    }
}
