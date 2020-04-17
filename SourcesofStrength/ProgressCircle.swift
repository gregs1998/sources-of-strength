//
//  ProgressCircle.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/16/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct RectangleFrame: View{
    
    var body: some View{
        ZStack{
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width:350, height:300)
                .foregroundColor(.white)
                .shadow(radius: 50)
        }
    }
}


struct ProgressCircle: View {
    // 1.
    var progress: CGFloat
    var goalName: String
    var goal: CGFloat
    var color: Color
    
    
    var body: some View {
        VStack{
            ZStack {
                RectangleFrame()
                // 3.
                VStack(alignment: .leading){
                    Text(goalName)
                        .padding(.bottom, 15)
                        .padding(.leading, 30)
                        .font(.system(size:32, weight: .bold))
                        .foregroundColor(color)
                    ZStack{
                        Circle()
                            .stroke(Color.gray, lineWidth: 20)
                            .opacity(0.1)
                            .frame(height: 175)
                        // 4.
                        Circle()
                            .trim(from: 0, to: progress/goal)
                            .stroke(color, lineWidth: 20)
                            .rotationEffect(.degrees(-90))
                            .frame(height: 175)
                            // 5.
                            .overlay(
                                Text("\(Int(progress/goal * 100.0))%"))
                            .font(.system(size: 32, weight:.bold))
                            .foregroundColor(color)
                    }
                }
                
            }.padding(20)
            
            
            Spacer()
        }
    }
}

//struct ProgressCircle_Previews: PreviewProvider {
//    
//    @State var progressTest:CGFloat = 5.0
//    
//    static var previews: some View {
//        ProgressCircle(progress: CGFloat(5.0), goalName: "Family Support", goal: kFAMILYSUPPORT_GOALVAL, color:.orange)
//    }
//}
