//
//  StorageManager.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/10.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager{
    
    static let shared = StorageManager()
    private init(){}
    
    private let storage = Storage.storage().reference()
    
    private var imageRef:StorageReference{  //이미지 폴터경로
        storage.child("iamges")
    }
    
    private func userReferance(userId:String,mode:ImageSaveFilter) -> StorageReference{  //메타데이터
        switch mode{
        case .page:
            return storage.child("page_image").child(userId)
        case .profile:
            return storage.child("users").child(userId)
        case .schedule:
            return storage.child("schedule").child(userId)
        }
    }
    
    private func getProfileImageURL(path:String) -> StorageReference{   //이미지 Url 가져오다
        Storage.storage().reference(withPath: path)
    }
    
    func getUrlForImage(path:String) async throws -> URL{   //메타데이터 경로 다운로드
        try await getProfileImageURL(path: path).downloadURL()
    }
    func saveImage(data:Data,userId:String,mode:ImageSaveFilter)async throws -> String{
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReferance(userId: userId,mode: mode).child(path).putDataAsync(data,metadata: meta)
        
        guard let returnedpPath = returnedMetaData.path else{
            throw URLError(.badServerResponse)
        }
        
        return returnedpPath
        
    }
    func deleteImage(path:String) async throws{
        try await getProfileImageURL(path: path).delete()
    }
    
    
    
}



