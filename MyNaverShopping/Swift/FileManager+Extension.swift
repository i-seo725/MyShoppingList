//
//  FileManager.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//
import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectory
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let path = documentDirectoryPath() else {
            print("Document 위치 찾기 실패")
            return
        }
        
        let fileURL = path.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            print("이미지 변환 실패")
            return
        }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("파일 저장 실패: ", error)
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage {
        guard let path = documentDirectoryPath() else {
            print("Document 위치 찾기 실패")
            return UIImage(systemName: "xamrk")!
        }
        
        let fileURL = path.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path) ?? UIImage(systemName: "xmark")!
        } else {
            return UIImage(systemName: "xmark")!
        }
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let path = documentDirectoryPath() else {
            print("Document 위치 찾기 실패")
            return
        }
        
        let fileURL = path.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("파일 삭제 실패: ", error)
        }
        
    }
    
}
