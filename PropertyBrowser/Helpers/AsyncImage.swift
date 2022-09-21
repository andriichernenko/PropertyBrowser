//
//  AsyncImage.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import SwiftUI

struct AsyncImage: View {
    @StateObject var viewModel: ViewModel
    
    let aspectRatio: CGSize
    
    init(url: URL, aspectRatio: CGSize) {
        self._viewModel = .init(wrappedValue: ViewModel(url: url))
        self.aspectRatio = aspectRatio
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .succeeded(let image):
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }

            case .failed:
                Image(systemName: "photo.fill")
                    .imageScale(.large)
                    .foregroundColor(.secondaryText)
                
            default:
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .aspectRatio(aspectRatio, contentMode: .fill)
        .background(Color.imagePlaceholder)
        .onAppear { viewModel.viewDidAppear() }
    }
    
    init(viewModel: ViewModel, aspectRatio: CGSize) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.aspectRatio = aspectRatio
    }
}

extension AsyncImage {
    
    class ViewModel: ObservableObject {
        let url: URL
        
        @Published var state: State<UIImage> = .idle
        
        init(url: URL) {
            self.url = url
        }
                
        func viewDidAppear() {
            guard case .idle = state else { return }
            
            state = .loading
            
            Task {
                do {
                    // TODO: Handle network errors
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    guard let image = UIImage(data: data) else {
                        throw AsyncImageError.decodingFailed
                    }
                                        
                    await MainActor.run { state = .succeeded(value: image) }
                } catch {
                    await MainActor.run { state = .failed(error: error) }
                }
            }
        }
        
        init(state: State<UIImage>) {
            self.url = mockPropertyItem.imageURL
            self.state = state
        }
    }
}

enum AsyncImageError: Error {
    case decodingFailed
}

let mockImage = UIImage(named: "mockPropertyImage")!

struct AsyncImage_Previews: PreviewProvider {

    static var previews: some View {
        ScrollView {
            AsyncImage(
                viewModel: .init(state: .succeeded(value: mockImage)),
                aspectRatio: .highlightedImageAspectRatio
            )
            
            AsyncImage(
                viewModel: .init(state: .succeeded(value: mockImage)),
                aspectRatio: .normalImageAspectRatio
            )
            
            AsyncImage(
                viewModel: .init(state: .loading),
                aspectRatio: .normalImageAspectRatio
            )
            
            AsyncImage(
                viewModel: .init(state: .failed(error: AsyncImageError.decodingFailed)),
                aspectRatio: .normalImageAspectRatio
            )
        }
        .padding(16)
    }
}
