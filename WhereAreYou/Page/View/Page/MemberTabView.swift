//
//  MemberTabView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI
import Kingfisher

struct MemberTabView: View {
    
    
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var vm:PageViewModel
    
    var admin:UserData?{
        vm.member.first(where: {$0.userId == vm.page?.pageAdmin})
    }
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            Section("방장"){
                MemberListRowView(image: admin?.profileImageUrl ?? "", name: admin?.nickName ?? "",admin: true)
            }
            .padding(.bottom)
            Divider()
                .padding(.bottom)
            Section("맴버"){
                if vm.member.filter({$0 != admin}).isEmpty{
                    emptymember
                }else{
                    ForEach(vm.member.filter({$0 != admin}),id:\.self){ member in
                        MemberListRowView(image: member.profileImageUrl ?? "", name: member.nickName ?? "",admin: false)
                            .overlay(alignment:.trailing){
                                if vmAuth.user?.userId == vm.page?.pageAdmin{
                                    Button {
                                        guard let page = vm.page else {return}
                                        vm.accept = true
                                        vm.kickMember(userId: member.userId, pageId: page.pageId)
                                    } label: {
                                        Text("강퇴")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                            .padding(5)
                                            .background(Color.customCyan2.opacity(0.7))
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.top)
                            
                    }
                    
                }
            }
        }
        .onReceive(vm.requsetDismiss){ page in
            vm.accept = false
        }
        .padding()
    }
}

struct MemberTabView_Previews: PreviewProvider {
    static var previews: some View {
        
        MemberTabView()
            .environmentObject(PageViewModel(page: nil, pages: CustomDataSet.shared.pages()))
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
        
    }
}

extension MemberTabView{
    var emptymember:some View{
        HStack{
            Image(systemName: "person.fill.xmark")
            Text("아직 맴버가 없습니다.")
        }
        .foregroundColor(.gray.opacity(0.5))
        .padding(.vertical)
    }
    
}


