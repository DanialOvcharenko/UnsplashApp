//
//  Home.swift
//  UnsplashApp
//
//  Created by Mac on 21.01.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    
    @State var expand = false
    @State var search = ""
    @ObservedObject var RandomImages = getData()
    @State var page = 1
    @State var isSearching = false
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
                
                if !self.expand {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("UnSplash")
                            .foregroundColor(.primary)
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Good Free Photos")
                            .foregroundColor(.primary)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        withAnimation {
                            self.expand = true
                        }
                    }
                
                if self.expand {
                    TextField("Search...", text: self.$search)
                        .foregroundColor(.primary)
                    
                    if self.search != "" {
                        Button {
                            
                            //Deleting all existing data and displaying search
                            self.RandomImages.Images.removeAll()
                            
                            self.isSearching = true
                            self.page = 1
                            
                            //Searching....
                            self.RandomImages.SearchQuery(quer: self.search, page: page)
                            
                            
                        } label: {
                            Text("Find")
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }

                    }
                    
                    Button {
                        withAnimation {
                            self.expand = false
                        }
                        
                        self.search = ""
                        
                        if self.isSearching {
                            
                            self.isSearching = false
                            self.RandomImages.Images.removeAll()
                            self.RandomImages.updateData()
                        }
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading,10)
                }
            }
            .padding()
            .background(Color("HeaderColor"))
            
            if self.RandomImages.Images.isEmpty {
                
                Spacer()
                
                // Data is loading or no data
                if self.RandomImages.noresults{
                    Text("No Results Found")
                } else {
                    Indicator()
                }
                
                Spacer()
                
            } else {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 15) {
                        
                        ForEach(self.RandomImages.Images, id: \.self) { i in
                            
                            HStack(spacing: 20) {
                                
                                ForEach(i) { j in
                                    
                                    NavigationLink(destination: {
                                        
                                        DeteilView(urlString: j.urls["small"]!)
                                        
                                    }, label: {
                                        
                                        AnimatedImage(url: URL(string: j.urls["thumb"]!))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 200)
                                            .cornerRadius(15)
                                            .contextMenu {
                                                Button {
                                                    
                                                    SDWebImageDownloader()
                                                        .downloadImage(with: URL(string: j.urls["small"]!)) { (image, _, _, _) in
                                                            
                                                            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                                                        }
                                                    
                                                } label: {
                                                    HStack{
                                                        Text("Save")
                                                        Spacer()
                                                        Image(systemName: "square.and.arrow.down.fill")
                                                    }
                                                    .foregroundColor(.black)
                                                }
                                            }
                                        
        
                //MARK: - If we don't use SDWebImageSwiftUI, we can change AnimatedImage to AsyncImage
                                        
    //                                    AsyncImage(url: URL(string: j.urls["thumb"]!)) { image in
    //                                        image
    //                                            .resizable()
    //                                            .aspectRatio(contentMode: .fill)
    //                                    } placeholder: {
    //                                        ProgressView()
    //                                    }
    //                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 200)
    //                                        .cornerRadius(15)
                //
                                    })
                                    
                                    
                                }
                            }
                            
                        }
                        
                        if !self.RandomImages.Images.isEmpty {
                            
                            if self.isSearching && self.search != ""{
                                
                                HStack {
                                    Text("Page \(self.page)")
                                    Spacer()
                                    
                                    Button {
                                        
                                        self.RandomImages.Images.removeAll()
                                        self.page += 1
                                        self.RandomImages.SearchQuery(quer: self.search, page: page)
                                        
                                    } label: {
                                        Text("Next")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                    }

                                }
                                .padding(.horizontal,25)
                                
                            } else {
                                
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        
                                        self.RandomImages.Images.removeAll()
                                        self.RandomImages.updateData()
                                        
                                    } label: {
                                        Text("Next")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                    }

                                }
                                .padding(.horizontal,25)
                            }
                            
                            
                        }
                        
                        Spacer()
                            .frame(height: 12)
                    }
                    .padding(.top)
                    
                }
                .background(Color("ContentColor"))
                
            }
            
            Spacer()
            
        }
        
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
    
    
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}






//MARK: - Indicator of loading images

struct Indicator: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
