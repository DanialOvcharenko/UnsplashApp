//
//  DeteilView.swift
//  UnsplashApp
//
//  Created by Mac on 21.01.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DeteilView: View {
    
    var urlString: String
    @State private var showAlert: Bool = false
    @State var imageScale: CGFloat = 1
    @State var isSaved = false
    
    var body: some View {
        
        
        VStack{
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(imageScale)
                    .gesture (
                        MagnificationGesture().onChanged { (value) in
                            imageScale = value
                        }.onEnded { _ in
                            withAnimation(.spring()) {
                                imageScale = 1
                            }
                        }
                    )
            } placeholder: {
                ProgressView()
            }
            .frame(width: UIScreen.main.bounds.width - 20)
            .cornerRadius(15)
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAlert.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.primary)
                        .font(.system(size: 18))
                    
                }
                .alert(isPresented: $showAlert, content: {
                    
                    Alert(
                        title: Text("Shure?"),
                        message: Text(isSaved == true ? "You just save this photo. Do you want more?" : "Do you realy want to save this photo?"),
                        primaryButton: .default(Text("Yes")) {
                            
                            SDWebImageDownloader()
                                .downloadImage(with: URL(string: urlString)) { (image, _, _, _) in
                                    
                                    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                                }
                            
                            isSaved = true
                            
                        },
                        secondaryButton: .cancel(Text("No, thanks")))
                })
            }
        }
        
        
    }
}

struct DeteilView_Previews: PreviewProvider {
    static var previews: some View {
        DeteilView(urlString: "")
    }
}
