//
//  ConverterController.swift
//  CurrencyCourses
//
//  Created by Dmitriy Lee on 8/14/20.
//  Copyright © 2020 LEES Entertainment. All rights reserved.
//

import UIKit

class ConverterController: UIViewController {

    @IBOutlet weak var labelCoursesForDate: UILabel!
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    
    @IBAction func pushFromAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    @IBAction func pushToAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFrom.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshButtons()
        textFromEditingChange(self)
        navigationItem.rightBarButtonItem = nil
    }
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBAction func pushDoneAction(_ sender: Any) {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func textFromEditingChange(_ sender: Any) {
        let amount = Double(textFrom.text!)
            textTo.text = Model.shared.convert(amount: amount)
    }
    
    func refreshButtons() {
        buttonFrom.setTitle(Model.shared.fromCurrency.title, for: UIControl.State.normal)
        buttonTo.setTitle(Model.shared.toCurrency.title, for: UIControl.State.normal)
    }

}

extension ConverterController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = buttonDone
        return true
    }
}
