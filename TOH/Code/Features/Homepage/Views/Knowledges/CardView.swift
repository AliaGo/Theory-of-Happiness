//
//  CardView.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import Foundation
import SwiftUI
import FirebaseAnalytics

struct CardView: View {
    //@Environment(ModelData.self) var modelData
    @StateObject private var viewModel = CardViewModel()
    
    @State private var isShowingAnswerSheet = false
    @State private var answerSheetContent = ""
    @State private var answerSheetDetail = ""
    
    var type: String
    
    var body: some View {
        let columns = [GridItem(), GridItem()]
        ZStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns){
                    ForEach(viewModel.cards.sorted(by: { $0.id < $1.id }), id: \.id) { qAndA in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.myBackground)
                            .frame(width:180, height: 150)
                            .overlay {
                                VStack {
                                    Text(String(qAndA.id))
                                        .font(.title3)
                                        .foregroundColor(.gray)
                                    Text(qAndA.question)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                            }
                            .onTapGesture {
                                isShowingAnswerSheet.toggle()
                                answerSheetContent = qAndA.answer
                                answerSheetDetail = qAndA.description ?? (qAndA.url ?? "")
                            }
                        
                    }
                }
            }
            
            CardAnswerPopOverView(showPopOver: $isShowingAnswerSheet, contentAnswer: answerSheetContent, contentDetail: answerSheetDetail)
                .padding(.top, 100)
                .offset(y: isShowingAnswerSheet ? 0 : UIScreen.main.bounds.height)
                .animation(.easeIn, value: isShowingAnswerSheet)
            
        }
        .onAppear {
            // 追蹤畫面瀏覽
            Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "CardView",
                    AnalyticsParameterScreenClass: "CardView"
                  ])
        }
        .task {
            try? await viewModel.loadCards(for: type)
        }
    }
    
}

struct CardAnswerPopOverView: View {
    //@Environment(\.presentationMode) var presentationMode
    @Binding var showPopOver: Bool
    var contentAnswer: String
    var contentDetail: String
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                showPopOver.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .padding(20)
            })
            
            VStack {
                //Spacer()
                Text(contentAnswer)
                    .font(.title2)
                    .padding(.top, 60)
                
                Text(contentDetail)
                    .font(.system(size: 18))
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }
        }
        //.frame(width:UIScreen.main.bounds.width-50, height: 350)
        //.background(Color.black)
        
    }
}

struct CardSingleView: View {
    let card: Card
    @State private var isShowingQuestion = true
    @State private var isShowingAnswer = false
    @State private var isShowingDescription = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(radius: 10)

            VStack {
                if isShowingQuestion {
                    if let topic = card.topic {
                        Text(topic)
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                    
                    Text(card.question)
                        .font(.title)
                        .foregroundStyle(.black)
                }
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.footnote)
                        .foregroundStyle(.black)
                    Button {
                        isShowingDescription.toggle()
                    } label: {
                        Capsule()
                            .fill(Color.myGreen2)
                            .overlay {
                                Text("check the detail")
                            }
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 200)
        .onTapGesture {
            isShowingQuestion.toggle()
            isShowingAnswer.toggle()
        }
        
        /*
        Button {
            
        } label: {
            VStack {
                Text("Next")
                    .foregroundStyle(.myBlue)
                    .font(.system(size: 30))
            }
        }
        .tint(.blue)
        .buttonStyle(.bordered)
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 150, height: 50)
         */
    }
}

