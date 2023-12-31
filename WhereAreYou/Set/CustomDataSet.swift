//
//  CustomDataSet.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/11.
//

import Foundation
import FirebaseFirestore

class CustomDataSet{
    static let shared  = CustomDataSet()
    private init(){}

    let basicImage = "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/%E1%84%8B%E1%85%B3%E1%84%83%E1%85%B5%E1%84%89%E1%85%B5%E1%86%B7.png?alt=media&token=a1460508-cdb3-4ff7-935e-8b3eea55530b"
    
    let images = [
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2016.png?alt=media&token=0938bc0d-1be3-43cd-882b-35822789b435",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2017.png?alt=media&token=73705217-762f-4772-88e0-b7e90a00a775",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2018.png?alt=media&token=3a2b9c5c-a1e6-44ce-81c0-1927f965800f",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2019.png?alt=media&token=aab22f97-c235-4dc2-b530-cf3f2c000a45",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2020.png?alt=media&token=ddca2cdc-2939-4a12-bf72-7c9b7d468d29",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2021.png?alt=media&token=d33bd32b-cc68-49d4-9c5c-3300d45dee39",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2022.png?alt=media&token=ef2264ec-4e35-44d3-b61f-12002fd359a7",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2023.png?alt=media&token=a1003133-8e84-435e-be01-d3633c5fa0a3"
    
    ]

    func page() -> Page{
        Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.images.first!, pageImagePath: nil, pageName: "으딩이", pageOverseas: false, pageSubscript: "으딩이와 함께 하는 우리어디가", request: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],members: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],dateRange: [Timestamp(date: "2023년 07월 26일".toDate()),Timestamp(date: "2023년 07월 27일".toDate()),Timestamp(date: "2023년 07월 28일".toDate()),Timestamp(date: "2023년 07월 29일".toDate())])
    }
    
    func schedule() -> Schedule{
        Schedule(id:"asdasdas",imageUrl:"https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/page_image%2F4KYzTqO9HthK3nnOUAyIMKcaxa03%2F125AFB52-3B93-4F16-B101-09AC390A6715.jpeg?alt=media&token=f98a6c58-c46f-474c-bf81-ff3fe7c09e00", category: "카페/휴식", title: "아무", startTime: "1:00PM".toDate().toTimestamp(), endTime: "3:00PM".toDate().toTimestamp()  , content: "아무게\n아무게", location: GeoPoint(latitude: 36.298959, longitude: 127.354729), link:["asd":"https://console.firebase.google.com/u/0/project/whereareyou-66f3a/firestore/data/~2Fusers~2F4KYzTqO9HthK3nnOUAyIMKcaxa03~2Fpage~2F6DORTzvH6zavb7g49BrB~2Fschedule?hl=ko"])
    }
    func pages() -> [Page]{
        [
            Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.images.first!, pageImagePath: nil, pageName: "으딩이", pageOverseas: false, pageSubscript: "으딩이와 함께 하는 우리어디가", request: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],members: ["4KYzTqO9HthK3nnOUAyIMKmembers"],dateRange: [Timestamp(date: "2023년 07월 26일".toDate()),Timestamp(date: "2023년 07월 27일".toDate()),Timestamp(date: "2023년 07월 28일".toDate()),Timestamp(date: "2023년 07월 29일".toDate())]),
            Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.images.first!, pageImagePath: nil, pageName: "으딩이", pageOverseas: false, pageSubscript: "으딩이와 함께 하는 우리어디가", request: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],members: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],dateRange: [Timestamp(date: "2023년 07월 26일".toDate()),Timestamp(date: "2023년 07월 27일".toDate()),Timestamp(date: "2023년 07월 28일".toDate()),Timestamp(date: "2023년 07월 29일".toDate())]),
            Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.images.first!, pageImagePath: nil, pageName: "으딩이", pageOverseas: false, pageSubscript: "으딩이와 함께 하는 우리어디가", request: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],members: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],dateRange: [Timestamp(date: "2023년 07월 26일".toDate()),Timestamp(date: "2023년 07월 27일".toDate()),Timestamp(date: "2023년 07월 28일".toDate()),Timestamp(date: "2023년 07월 29일".toDate())])
         
         
         
         ]
    }

}
