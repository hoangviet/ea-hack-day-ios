//
//  SettingViewController.swift
//  ChungKhoan
//
//  Created by Hoang Viet on 9/27/15.
//  Copyright (c) 2015 chungkhoan. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var bottomPriceTextField: UITextField!
    @IBOutlet weak var ceilingPriceTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    var viewModel: SettingViewModel!
    var stickerID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let stickerID = self.stickerID {
            self.viewModel = SettingViewModel(stickerID: stickerID)
            self.bindViewModel()
        }
    }

    func bindViewModel() {
        self.bottomPriceTextField.rac_textSignal().toSignalProducer().start(next: { [weak self] text in
            if let weakSelf = self, let text: AnyObject = text {
                weakSelf.viewModel.bottom = text.floatValue
            }
        })
        self.ceilingPriceTextField.rac_textSignal().toSignalProducer().start(next: { [weak self] text in
            if let weakSelf = self, let text: AnyObject = text {
                weakSelf.viewModel.ceiling = text.floatValue
            }
        })
    }

    @IBAction func updateButtonDidTouch(sender: AnyObject) {
        if self.viewModel == nil {
            return
        }
        self.viewModel.createPriceAlerts().start()
    }
}
