//
//  NaviController.swift
//  ARRuler
//
//  Created by Yigithan Narin on 12.05.2019.
//  Copyright © 2019 Yigithan Narin. All rights reserved.
//

import UIKit

class NaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationBar.shadowImage = UIImage()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
