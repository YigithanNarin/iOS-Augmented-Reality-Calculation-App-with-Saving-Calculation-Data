//
//  ViewController.swift
//  ARRuler
//
//  Created by Yigithan Narin on 21.04.2019.
//  Copyright © 2019 Yigithan Narin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate{

    
    
    
    
    //***Olayların yasandıgı ekran
    @IBOutlet var sceneView: ARSCNView!
    
    //***nokta belirlemek icin basılan buton
    @IBOutlet weak var Point: UIButton!
    
    //*** Sag ustteki save butonu
    @IBOutlet weak var kaydetbutton: UIButton!
    @IBOutlet weak var oldkaydetbutton: UIButton!
    
    //*** segmentedControl - Distance / Angle secenegi
    @IBOutlet weak var segmentSecenek: UISegmentedControl!
    
    //***uzunlugun yazıcagı label
    @IBOutlet weak var Label: UILabel!
    
    //***hesaplanıcak noktaların variableları
    var ilknokta : SCNNode?
    var ikincinokta : SCNNode?
    
     //*** orta nokta angle icin gerekli
    var ortanokta : SCNNode?
    
    
    //*** 3 ve 4. noktalar area hesabı icin gerekli
    var ucuncunokta : SCNNode?
    var dorduncunokta : SCNNode?

    
    
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //***Distance ve Angle olarak secenekler
    //*** SegmentControl degisirse herseyi resetliyoruz.
    @IBAction func secenek(_ sender: UISegmentedControl) {
        
        switch segmentSecenek.selectedSegmentIndex{
        case 0:
            print("Distance degisimi yapıldı")
            
            
        case 1:
            print("Angle degisimi yapıldı")
            
            
        default:
            print("default_degisim oldu")
        }
        
        
        
        //*** kaydet butonunu sakla
        kaydetbutton.isHidden = true
        Point.setTitle("First Point", for: .normal)
        
        
        
        //*** ekrandaki noktalar silinsin.
        ilknokta?.removeFromParentNode();
        ilknokta = nil
        ikincinokta?.removeFromParentNode();
        ikincinokta = nil
        ucuncunokta?.removeFromParentNode();
        ucuncunokta = nil
        dorduncunokta?.removeFromParentNode();
        dorduncunokta = nil
        ortanokta?.removeFromParentNode();
        ortanokta = nil
        
        
        //***Labeldaki yazıyı sil
        Label.text = ""
        
        
        //*** test - consola degisim yaz
        print(" Segment degisimi yapıldı")
    }
 
    
    
    //*** sol ust Records butonu aksiyonu
    @IBAction func OldKaydetAction(_ sender: Any) {
        
        
        /*
        let pop2upView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupSaveID") as! pop2upViewController
        
        self.addChildViewController(pop2upView)
        
        pop2upView.view.frame = self.view.frame
        self.view.addSubview(pop2upView.view)
        pop2upView.didMove(toParentViewController: self)
        
        
        
        */
        print("Kayıtları acma islemi yapıldı")
        
    }
    
    
    
    
    
    //*** sag ust Save butonu aksiyonu
    @IBAction func KaydetAction(_ sender: Any) {
        
        var textFieldTitle = UITextField()
    
        let alert = UIAlertController(title: "Add new calculation", message: Label.text , preferredStyle: .alert)
        
        let actionalert = UIAlertAction(title: "Save", style: .default) { (actionalert) in
            
            //***save e basınca yapılacaklar
            
            
            let newItem = Item
            
            newItem.title = textFieldTitle.text! + "-" + self.Label.text!
            
            itemArray.append(newItem)
            
            //123itemArray.append(textFieldDesc.text!)
            
            
            //*** Core data elemanı
            self.saveItems()
            
            
            
            
            //self.defaults.set(itemArray, forKey: "RulerArray")
            
            print("Adding alert item success")
        }
        let actionNOalert = UIAlertAction(title: "Cancel", style: .cancel) { (actionNOalert) in
            
            //***cancel basınca yapılacaklar
            
            print("Cancel alert item success")
        }
        
        alert.addTextField {(alertTextField) in alertTextField.placeholder = "Title"
            
            textFieldTitle = alertTextField
            
            
            
        }
        
        alert.addAction(actionNOalert)
        alert.addAction(actionalert)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
        //*** test konsola calısıyor yaz
        print("Kaydet islemi yapıldı")
    }
    
    //***data save etme methodu
    func saveItems(){
        
        //*** Core data elemanı
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            //*** datayı data file pathına yazıyoruz
            
            try data.write(to: dataFilePath!)
        }catch{
            print("Error from encoding item array, \(error)")
        }
        
    }
    
    //*** kaydedilmis datalara yani plistteki verilere ulasmak icin method
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print("Error from deconding item array, \(error)")
            }
        }
    }
    
    //***Butona basılınca yasanacak aksiyon
    
    @IBAction func PointAction(_ sender: Any) {
        
        switch segmentSecenek.selectedSegmentIndex{
        case 0:
            
            //*** ilk nokta yoksa ilk noktayı olustur
            if ilknokta == nil{
                
                ilknokta = noktaOlustur();
                //***ilk nokta olusturulduktan sonra, butondaki yazı "Second Point" olarak degistir
                Point.setTitle("Second Point", for: .normal);
                
                print("Distance ilk nokta olusturuldu")
            }
                //*** ilk nokta varsa ama ikinci nokta yoksa ikinci noktayı olustur
            else if ikincinokta == nil{
                ikincinokta = noktaOlustur();
                
                //*** iki nokta da varsa noktalar arası hesaplama yapılsın
                //*** hesaplanan uzunluk labela yazılsın.
                Label.text = calculation();
                //***ikinci nokta olusturulduktan sonra, butondaki yazı "Reset" olarak degistir
                Point.setTitle("Reset", for: .normal);
                
                
                //***  DATABASE TUSU
                //*** Save butonunu gorunur yapıyoruz
                kaydetbutton.isHidden = false
                
                print("Distance ikinci nokta olusturuldu")
                
            }
                
            else{
                //***reset'e basıldıktan sonra, butondaki yazı "First Point" olarak degistir
                kaydetbutton.isHidden = true
                Point.setTitle("First Point", for: .normal)
                
                //*** Resetlendikten sonra Labeldaki yazıyı sil
                Label.text = ""
                
                //*** reset'e basınca ekrandaki noktalar silinsin.
                ilknokta?.removeFromParentNode();
                ilknokta = nil
                ikincinokta?.removeFromParentNode();
                ikincinokta = nil
                
                print("distance resetlendi")
                
            }
            
            
            
            
        case 1:
            
            
            
            if ilknokta == nil{
                
                ilknokta = noktaOlustur();
                //***ilk nokta olusturulduktan sonra, butondaki yazı "Middle Point" olarak degistir
                Point.setTitle("Middle Point", for: .normal);
                
                print("angle ilk nokta olusturuldu")
            }
            else if ortanokta == nil{
                ortanokta = noktaOlustur();
                
                //***orta nokta olusturulduktan sonra, butondaki yazı "third point" olarak degistir
                Point.setTitle("Third Point", for: .normal);
                
                
                
                print("angle orta nokta olusturuldu")
                
            }
            else if ikincinokta == nil{
                ikincinokta = noktaOlustur();
                
                //***ikinci nokta olusturulduktan sonra, butondaki yazı " reset" olarak degistir
                Point.setTitle("Reset", for: .normal);
                
                //***angle hesaplanması icin gerekli func
                Label.text = angleHesaplama();
                //***  DATABASE TUSU
                //*** Save butonunu gorunur yapıyoruz
                kaydetbutton.isHidden = false
                
                print("angle ucuncu nokta olusturuldu")
                
            }
            else{
                //***reset'e basıldıktan sonra, butondaki yazı "First Point" olarak degistir
                kaydetbutton.isHidden = true
                Point.setTitle("First Point", for: .normal)
                
                //*** Resetlendikten sonra Labeldaki yazıyı sil
                Label.text = ""
                
                //*** reset'e basınca ekrandaki noktalar silinsin.
                ilknokta?.removeFromParentNode();
                ilknokta = nil
                ortanokta?.removeFromParentNode();
                ortanokta = nil
                ikincinokta?.removeFromParentNode();
                ikincinokta = nil
                
                
                print("angle resetlendi")
                
            }
        case 2:
            //*** ilk nokta yoksa ilk noktayı olustur
            if ilknokta == nil{
                
                ilknokta = noktaOlustur();
                //***ilk nokta olusturulduktan sonra, butondaki yazı "Second Point" olarak degistir
                Point.setTitle("Second Point", for: .normal);
                
                print("Area ilk nokta olusturuldu")
            }
                //*** ilk nokta varsa ama ikinci nokta yoksa ikinci noktayı olustur
            else if ikincinokta == nil{
                ikincinokta = noktaOlustur();
                
                
                //***ikinci nokta olusturulduktan sonra, butondaki yazı "3. nokta" olarak degistir
                Point.setTitle("Third Point", for: .normal);
                
                print("Area ikinci nokta olusturuldu")
                
            }
            else if ucuncunokta == nil{
                ucuncunokta = noktaOlustur();
                
                
                //***ucuncu nokta olusturulduktan sonra, butondaki yazı "4. nokta" olarak degistir
                Point.setTitle("Forth Point", for: .normal);
                
                print("Area ucuncu nokta olusturuldu")
                
            }
            
            else if dorduncunokta == nil{
                dorduncunokta = noktaOlustur();
                
                
                //***ucuncu nokta olusturulduktan sonra, butondaki yazı "4. nokta" olarak degistir
                Point.setTitle("Reset", for: .normal);
                
                Label.text = areaHesaplama();
                
                //***  DATABASE TUSU
                //*** Save butonunu gorunur yapıyoruz
                kaydetbutton.isHidden = false
                
                print("Area dorduncu nokta olusturuldu")
                
            }
                
            else{
                //***reset'e basıldıktan sonra, butondaki yazı "First Point" olarak degistir
                kaydetbutton.isHidden = true
                Point.setTitle("First Point", for: .normal)
                
                //*** Resetlendikten sonra Labeldaki yazıyı sil
                Label.text = ""
                
                //*** reset'e basınca ekrandaki noktalar silinsin.
                ilknokta?.removeFromParentNode();
                ilknokta = nil
                ikincinokta?.removeFromParentNode();
                ikincinokta = nil
                ucuncunokta?.removeFromParentNode();
                ucuncunokta = nil
                dorduncunokta?.removeFromParentNode();
                dorduncunokta = nil
                
                print("Area resetlendi")
                
            }
            
            
            
            
        default:
            
            
            
            print("button tarafından default oldu")
        }
        
        
            
            
    
    }
    
    
  
   // @IBAction func PointAction(_ sender: Any) {}
    
    
    //*** iki nokta arasındaki uzunlugu hesaplayan fonkisyon.
    func calculation() -> String{
        
        //*** optionaldan normal degere ceviriyoruz
        if let ilknokta = ilknokta{
            if let ikincinokta = ikincinokta{
                
                //*** 3 boyutlu olarak calıstıgımız icin vector olarak hesaplamamız gerekiyor.
                let vec = SCNVector3Make(ikincinokta.position.x - ilknokta.position.x,
                                         ikincinokta.position.y - ilknokta.position.y,
                                         ikincinokta.position.z - ilknokta.position.z)
                
                let uzunluk = sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
                
                
                
                //*** uzunluk 1 den buyukse metre kucukse cm olarak goster
                if uzunluk >= 1
                {
                    
                    
                    //*** mesafenin sonucunu donduruyoruz
                    //*** cıkan sayı cok kusuratlı oldugu icin yuvarlıyoruz
                    return String(format: "Distance: %.3f meter", uzunluk);
                }
                else{
                    
                    //*** metreyi cm olarak ceviriyoruz bu yuzden *100 yapıyoruz
                    let uzunluk = uzunluk * 100;
                    //*** mesafenin sonucunu donduruyoruz
                    //*** cıkan sayı cok kusuratlı oldugu icin yuvarlıyoruz
                    return String(format: "Distance: %.3f cm", uzunluk);
                }
                
                
                
            }
        }
        
        //*** mesafe bulamazsa bos donduruyoruz.
        return "";
    }
    
    
    
    //*** alan hesaplaması yapan fonksiyon
    func areaHesaplama() -> String{
        if let ilknokta = ilknokta{
            if let ikincinokta = ikincinokta{
                if let ucuncunokta = ucuncunokta{
                    if let dorduncunokta = dorduncunokta{
                        
                        let vecEn = SCNVector3Make(ikincinokta.position.x - ilknokta.position.x,
                                                   ikincinokta.position.y - ilknokta.position.y,
                                                   ikincinokta.position.z - ilknokta.position.z)
                        let uzunlukEn = (sqrt(vecEn.x * vecEn.x + vecEn.y * vecEn.y + vecEn.z * vecEn.z)) * 100;
                        
                        let vecBoy = SCNVector3Make(dorduncunokta.position.x - ucuncunokta.position.x,
                                                    dorduncunokta.position.y - ucuncunokta.position.y,
                                                    dorduncunokta.position.z - ucuncunokta.position.z)
                        let uzunlukBoy = (sqrt(vecBoy.x * vecBoy.x + vecBoy.y * vecBoy.y + vecBoy.z * vecBoy.z)) * 100;
                        
                        let Alan = uzunlukEn * uzunlukBoy;
                        
                        print(Alan);
                        print("Alan hesaplaması yapıldı");
                        
                        return String(format: "Area: %.2f cm²", Alan);
                        
                    }
                }
            }
        }
        
        
        
        return "";
    }
    
    //*** acı hesaplamak icin kullanılan fonksiyon
    func angleHesaplama() -> String{
        
        if let ilknokta = ilknokta{
            if let ortanokta = ortanokta{
                if let ikincinokta = ikincinokta{
                    
                    //***uzaydaki x,y,z kordinatları verilen 3 noktanın arasında olusan 2 kesisen dogrunun olusturdugu acıyı hesaplamak icin kullandıgım formul.
                    //***formul = verilen 3 noktanın icinden 2 tane vektor cıkartıyoruz. orta nokta iki vektordede aynı oldugu icin, iki vektor kesisiyor ve aralarında bi acı olmus oluyor. A vektoru ile B vektorunun dot productı bolu A vektorunun uzunlugu carpı B vektorunun uzunlugu. Bu formul bize acının Cos unu verir. Yani Cos(X).  Burdan X i cıkartıyoruz ve acıyı bulmus oluyoruz.
                    
                    
                    //***       ^
                    //***      /                               (A . B)
                    //***     /                     Cos(X)=  ------------
                    //***    /                               ( IAI . IBI )
                    //***   /__  X
                    //***  /___\___________>        arccos yaparak X acısını buluyoruz
                    
                    
                    let vec1 = SCNVector3Make(ortanokta.position.x - ilknokta.position.x,
                                              ortanokta.position.y - ilknokta.position.y,
                                              ortanokta.position.z - ilknokta.position.z)
                    let vec2 = SCNVector3Make(ikincinokta.position.x - ortanokta.position.x,
                                              ikincinokta.position.y - ortanokta.position.y,
                                              ikincinokta.position.z - ortanokta.position.z)
                    let ust = (vec1.x * vec2.x) + (vec1.y * vec2.y) + (vec1.z * vec2.z)
                    let alt1 = sqrt((vec1.x * vec1.x) + (vec1.y * vec1.y) + (vec1.z * vec1.z))
                    let alt2 = sqrt((vec2.x * vec2.x) + (vec2.y * vec2.y) + (vec2.z * vec2.z))
                    let alt = alt1 * alt2
                    let formul = ust / alt
                    let π = 3.1415926536
                    let sonuc = 180 - ( Double(acos(formul)) * Double(180) / Double(π) )
                    
                    print(sonuc);
                    
                    print("angle hesaplaması yapıldı");
                    
                    
                    return String(format: "Angle: %.2f °", sonuc);
                }
            }
        }
        
        return "";
    }
    
    //***ekrana bir nokta olusturmak icin fonksiyon
    func noktaOlustur() -> SCNNode? {
        //***Kullanıcı nereye dokundu onu gostermemiz gerekiyo
        let kullanıcıDokunması = sceneView.center;
        let sonuclar = sceneView.hitTest(kullanıcıDokunması, types: .featurePoint);
        //***Secilen yeri alıyoruz
        if let sonuc1 = sonuclar.first{
            //***Secilen yere bi sekil bırakıyoruz
            //*** sekile orta bir deger verdik
            let nokta = SCNBox(width: 0.0099, height: 0.0099, length: 0.0099, chamferRadius: 0.0099)
            //*** sekile bir materyal (gorunen madde gibi bisey) veriyoruz
            let madde = SCNMaterial();
            //***sekili mavi yaptık
            madde.diffuse.contents = UIColor.blue;
            nokta.firstMaterial = madde;
            //*** olusturdugumuz sekli ekrana koyucaz, kullanıcı gorebilsin diye
            let noktaNode = SCNNode(geometry: nokta);
            //*** Olusturdugumuz sekli 3 boyutlu olarak ayarlıyoruz, x y z degerleri gerekiyor.
            noktaNode.position = SCNVector3(sonuc1.worldTransform.columns.3.x,
                                            sonuc1.worldTransform.columns.3.y,
                                            sonuc1.worldTransform.columns.3.z)
            
            //*** ekrana ekliyoruz
            sceneView.scene.rootNode.addChildNode(noktaNode);
            return noktaNode
        }
        Label.text = "Camera Failed"
        //*** sonuc1'i alamazsak null dondursun
        return nil;
    }
    
    
    //***App load oldugunda olucaklar
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //*** Save butonunu gizliyoruz cunku sadece bir deger alındıgı zaman bu buton acık olacak.
        kaydetbutton.isHidden = true
        
        //*** dugmenin sekli yuvarlak olsun
        Point.layer.cornerRadius = 30;
        Point.layer.masksToBounds = true;
        
        kaydetbutton.layer.cornerRadius = 10;
        kaydetbutton.layer.masksToBounds = true;
        
        oldkaydetbutton.layer.cornerRadius = 10;
        oldkaydetbutton.layer.masksToBounds = true;
        
        
        segmentSecenek.layer.cornerRadius = 5;
        segmentSecenek.layer.masksToBounds = true;
        
        
       // if let items = UserDefaults.standard.array(forKey: "RulerArray") as? [String]{
       //
       //   itemArray = items
       //}
        
        //*** kullanıcıların home directory
        print(dataFilePath)
        
        
       /*
        let newItem = Item()
        newItem.title = "Masa olcumu"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Defter olcumu"
        itemArray.append(newItem2)
        */
        
        
        
       // if let items = defaults.array(forKey: "RulerArray") as? [Item] {
         //   itemArray = items
        // }
        loadItems()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        //*** Statistikleri true yaparsak ekranın alt kısmında fps ve timing degerlerini gostericek.
        sceneView.showsStatistics = false
        
        //*** labelı temizleme islemi
        Label.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //***yataydaki mesafeyi olcebilmek icin.
        configuration.planeDetection = .horizontal;
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
