//
//  Loading.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 27.11.2025.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Loading...")
                    .font(.custom("Poppins-SemiBold", size: screenHeight * 0.028))
                    .foregroundColor(Color("text_1Color"))
                    .padding(.bottom)
            }
        }
    }
}

#Preview {
    Loading()
}
