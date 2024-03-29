//
//  EditViewModel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/22.
//

import Foundation
import PhotosUI
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

@MainActor
class PageViewModel:ObservableObject{
    
    //---------Firestore데이터 ------------
    @Published var page:Page? = nil
    @Published var schedule:Schedule? = nil
    @Published var pages:[Page] = []
    @Published var schedules:[Schedule] = []
    
    //---------- 기타공유 프로퍼티 -----------
    @Published var copy = false
    @Published var photo:String?
    
    //--------- 페이지 -------------
    @Published var request:[UserData] = []
    @Published var member:[UserData] = []
    
    //---------- 뷰 이벤트 -----------
    @Published var accept = false
    var addDismiss = PassthroughSubject<String,Never>()
    var pageDismiss = PassthroughSubject<(),Never>()
    var requsetDismiss = PassthroughSubject<Page,Never>()
    
    //
    //--------------페이지-----------------------
    //
    
    init(page:Page?,pages:[Page]){
        self.page = page
        self.pages = pages
    }
    //페이지 생성
    func creagtePage(user:UserData,pageInfo:Page,item:PhotosPickerItem?,image:String){
        
        Task{
            var url:String = ""
            var path:String? = nil

            if let data = try await item?.loadTransferable(type: Data.self){
                path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .page)
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "").absoluteString
            }else if !image.isEmpty{
                url = image
            }
            
            let pageId = try await PageManager.shared.createUserPage(userId: user.userId,url: url ,path: path, pageInfo: pageInfo)
            try await UserManager.shared.updatePages(userId: user.userId, pagesId: pageId)
            pages = try await PageManager.shared.getAllUserPage(userId: user.userId)
            addDismiss.send(pageId)
        }
    }
    //페이지 수정
    func updatePage(user:UserData,pageInfo:Page,item:PhotosPickerItem?,image:String){
        
        Task{
            var url:String = ""
            var path:String? = nil
            
            if let data = try await item?.loadTransferable(type: Data.self){
                path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .page)    //사진이 없었지만 추가하는 경우
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "").absoluteString
                
            }
            else if !image.isEmpty{
                url = image
            }
            try await PageManager.shared.upadateUserPage(userId: user.userId,url: url, path: path, pageInfo: pageInfo)
            self.page = try await PageManager.shared.getPage(pageId: pageInfo.pageId)
            addDismiss.send("")
        }
    }
    //페이지 삭제
    func deletePage(user:UserData,page:Page){
        Task{
            if let path = page.pageImagePath{
                try await StorageManager.shared.deleteImage(path: path) //페이지 이미지가 없을 경우 필요가 없는 부분
            }
            try await PageManager.shared.deleteUserPage(pageId: page.pageId)    //본인 페이지 삭제
            try await PageManager.shared.updateMemberPage(userId:user.userId,pageId: page.pageId)   //본인 정보에서 페이지id 삭제
            if let members = page.members{
                for member in members {
                    try await PageManager.shared.updateMemberPage(userId:member,pageId: page.pageId)    //해당 페이지에 속한 모든 멤버정보에서도 페이지id 삭제
                }
            }
            try await StorageManager.shared.deleteAllScheuleImage(userId: user.userId ,pageId: page.pageId)//페이지에 속했었던 모든 스케쥴 사진 삭제 - 디렉토리를 알아서 삭제됨
           
            pageDismiss.send()
        }
    }
    //페이지 나감
    func outPage(user:UserData,page:Page){
        Task{
            try await PageManager.shared.memberPage(userId: user.userId,pageId: page.pageId, cancel: true)   //본인 정보에 페이지id 삭제
            try await PageManager.shared.updateMemberPage(userId:user.userId,pageId: page.pageId)   //기본 페이지에 본인 멤버 목록에서 삭제
            pageDismiss.send()
        }
    }
    //페이지리스트 불러오기
    func getPages(user:UserData){
        Task{
            pages = try await PageManager.shared.getAllUserPage(userId: user.userId)
        }
    }
    //페이지 불러오기
    func getPage(pageId:String){
        Task{
            let page = try await PageManager.shared.getPage(pageId: pageId)
            self.page = page
            getMembers(page: page)
        }
    }
    
    //
    //--------------스케쥴-----------------------
    //
    
    //일정 생성
    func creagteShcedule(user:UserData,pageId:String,schedule:Schedule,item:PhotosPickerItem?,image:String){
        
        Task{
            var url:String = ""
            var path:String? = nil
            
            if let data = try await item?.loadTransferable(type: Data.self){
                path = try await StorageManager.shared.scheduleSaveImage(data:data,userId: user.userId, mode: .schedule, pageId: pageId)
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "").absoluteString
            }
            else if !image.isEmpty{
                url = image
            }
            
            let scheduleId = try await PageManager.shared.createUserSchedule(pageId: pageId, url: url, schedule: schedule,path:path)
            schedules = try await PageManager.shared.getAllUserSchedule(pageId: pageId)
            addDismiss.send(scheduleId)
        }
    }
    //일정 수정
    func updateSchedule(user:UserData,pageId:String,schedule:Schedule,item:PhotosPickerItem?,image:String){
        Task{
           
            var url:String = ""
            var path:String? = nil
            
            if let data = try await item?.loadTransferable(type: Data.self){
                path = try await StorageManager.shared.scheduleSaveImage(data:data,userId: user.userId, mode: .schedule, pageId: pageId)    //사진이 없었지만 추가하는 경우
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "").absoluteString
                
            }
            else if !image.isEmpty{
                url = image
            }
            try await PageManager.shared.updateUSerSchedule(userId: user.userId, pageId: pageId, url: url, schedule: schedule,path: path)
            addDismiss.send("")
        }
    }
    
    //일정 삭제
    func deleteSchedule(pageId:String,schedule:Schedule){
        Task{
            if let path = schedule.imageUrlPath{
                try await StorageManager.shared.deleteImage(path: path) //스케쥴 이미지가 없을 경우 필요가 없는 부분
            }
            try await PageManager.shared.deleteUserSchedule(pageId: pageId, scheduleId: schedule.id)
            getSchedules(pageId: pageId)
        }
    }
    
    //일정리스트 불러오기
    func getSchedules(pageId:String){
        Task{
            schedules = try await PageManager.shared.getAllUserSchedule(pageId: pageId)
        }
    }
    
    
    //
    //---------------기능------------------
    //
    
    //요청리스트와 맴버리스트 조회
    func getMembers(page:Page){
        Task{
            (self.request,self.member) = try await PageManager.shared.getMembersInfo(page:page)
        }
    }
    //페이지 요청 수락
    func userAccept(page:Page,requestUser:UserData){
        Task{
            try await PageManager.shared.acceptUser(pageId:page.pageId,requestUser:requestUser)
            let pageInfo = try await PageManager.shared.getPage(pageId: page.pageId)
            getMembers(page: pageInfo)
            self.page = pageInfo
            self.requsetDismiss.send(pageInfo)
        }
    }
    //페이지 요청
    func requestPage(user:UserData,pageId:String,cancel:Bool){
        Task{
            try await PageManager.shared.requestPage(userId:user.userId,pageId:pageId,cancel:!cancel)
            self.requsetDismiss.send(try await PageManager.shared.getPage(pageId: pageId))
        }
    }

    func kickMember(userId:String,pageId:String){
        Task{
            try await PageManager.shared.memberPage(userId:userId,pageId:pageId,cancel:true)
            try await PageManager.shared.updateMemberPage(userId: userId, pageId: pageId)
            let pageInfo = try await PageManager.shared.getPage(pageId: pageId)
            getMembers(page: pageInfo)
            self.page = pageInfo
            self.requsetDismiss.send(pageInfo)
        }
    }
    
    //
    //-------------------------기타--------------------------
    //
    
    //시작과 끝 날짜를 입력하면 그 사이에 있는 값을 배열로 반화
    func generateTimestamp(from: Date, to: Date) -> [Timestamp] {
        var currentDate = from
        var dateArray: [Timestamp] = []
        let calendar = Calendar.current
        
        while currentDate <= to {
            let midnightDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate)!
            dateArray.append(Timestamp(date: midnightDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dateArray
    }
    
    //클립보드 복사
    func copyToPasteboard(text:String) {
        UIPasteboard.general.string = text
        copy = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.copy = false
            }
        }
    }
    //현재 날짜가 입력한 날짜 범위안에 들어있는지 유무를 반환
    func isCurrentDateInRange(startDate: Date, endDate: Date) -> Bool {
        let currentDate = Date()
        if currentDate >= startDate && currentDate <= endDate {
            return true
        } else {
            return false
        }
    }
    
}








