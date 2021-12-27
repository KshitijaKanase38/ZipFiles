//
//  ViewController.swift
//  ZipFiles
//
//  Created by Coditas on 17/11/21.
//

import UIKit
import ZIPFoundation
import CryptoKit
class ViewController: UIViewController {
   
    @IBOutlet weak var key: UITextField!
    @IBAction func button(_ sender: UIButton) {
       // if key.text != nil{
            let data = getData(for: "cafe.png")
            //let str = String(decoding: publickeyData, as: UTF8.self)
//            let publicKey = try! Curve25519.Signing.PublicKey(rawRepresentation: publickeyData)
//            if key.text! == String(publicKey{
                let publicKey = try! Curve25519.Signing.PublicKey(rawRepresentation: publickeyData)
                if publicKey.isValidSignature(signature, for: data) {
                    let img = UIImage(data: data)
                    image.image = img
                    
                    print("Correct data.",data)
                }
            //}
       // }
        
        
    }
    
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //zipString()
        //ipImages(imageName: "thisIsTheZip.zip", completion: nil)
        encrypt(with: "zip.txt")
    
    }
    var publickeyData = Data()
    var signature = Data()
    func saveImages(name: String) -> URL? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        
        do {
            let filePath = Bundle.main.path(forResource: "cafe", ofType: "png")!
            let contentOfFile = FileManager.default.contents(atPath: filePath)!
            let abc = directory!.appendingPathComponent(name)
            try contentOfFile.write(to: abc)
            
            return abc
        } catch {
            return nil
        }
    }
    func zipImages(imageName:String,completion: ((URL?) -> ())? = nil) {
        DispatchQueue.main.async { [self] in
            guard let directory = saveImages(name: imageName) else {
                completion!(nil)
                return
            }
            print(directory)
            Archive(url: directory, accessMode: .create)
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: directory.path){
                extract(fileName: imageName, location: directory)
            }
            
        }
    }
    
    func extract(fileName : String, location: URL){
        
        let fileManager = FileManager()
        let fileURL = fileName
        // let currentWorkingPath = fileManager.currentDirectoryPath
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let doc = location.appendingPathComponent(fileName)
            // let atLocation = dir.appendingPathComponent("unZippedFile.png")
            do {
                // try fileManager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
                print("From:  ",location)
                print("TO : ",dir)
                try fileManager.unzipItem(at: location, to: dir)
                let zipData = NSData(contentsOfFile: location.path) as Data?
                //let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                print("EXTRACTED",zipData)
                
            } catch {
                print("Extraction of ZIP archive failed with error:\(error)")
            }
            
            
            
        }
    }
    //
    func getData(for item: String) -> Data {
        let filePath = Bundle.main.path(forResource: "cafe", ofType: "png")!
        let contentOfFile = FileManager.default.contents(atPath: filePath)!
//        var data = Data()
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(item)")
//
//        do{
//            data = try Data(contentsOf: path)
//            //return data
//        }
//        catch{
//            print("ERROR")
//        }
//        return data
        return contentOfFile
    }
    
    func encrypt(with name : String){
        
        let data = getData(for: "cafe.png")
        print("#########",data)
        
        // Create a 256-bit symmetric key
        
        let privateKey = Curve25519.Signing.PrivateKey()
      
        let publicKeyData = privateKey.publicKey.rawRepresentation
        publickeyData = publicKeyData
        // sign data (or digest) with the private key.
        let signatureForData = try! privateKey.signature(for: data)
        signature = signatureForData
        print("KEY : ",publicKeyData)
        let publicKey = try! Curve25519.Signing.PublicKey(rawRepresentation: publicKeyData)
        print("KEY-2 : ",publicKey)
        // Signing a digest of the data is faster:
       // let digest512 = SHA512.hash(data: data)
//        print("hash : ", digest512)
//        print("HAsh as data : ",Data(digest512))
//        let xyz = String(decoding: Data(digest512), as: UTF8.self)
//        print("hash as string : ",xyz)
//        let bbc = Data(xyz.utf8)
//
//        print("hash back as data : ",Data(bbc))
//        let signatureForDigest = try! privateKey.signature(
//            for: Data(digest512))
//
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        do {
            let fileLocation = directory!.appendingPathComponent(name)
            try signatureForData.write(to: fileLocation)
            let data = try Data(contentsOf: fileLocation)
            print("this is the data",data)
        } catch {
            print("ERROR WHILE SAVING")
        }
//
//
//        let publicKey = try! Curve25519.Signing.PublicKey(rawRepresentation: publicKeyData)
//        if publicKey.isValidSignature(signatureForData, for: data) {
//            let img = UIImage(data: data)
//            image.image = img
//
//            print("Correct data.",data)
//        }
//        if publicKey.isValidSignature(signatureForDigest,for: Data(digest512)) {
//            print("Data received == data sent.")
//            print(data)
//        }

        
    }
    
    
}
