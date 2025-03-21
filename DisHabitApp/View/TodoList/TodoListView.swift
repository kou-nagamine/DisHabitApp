//import Foundation
//import SwiftUI
//
//struct TodoListView: View {
//    
//    // proparty wrapper
//    @EnvironmentObject var dateModel : DateModel
//    @State private var showAlert = false
//    
//    let card: CardData
//    let namespace: Namespace.ID
//    let onDismiss: () -> Void
//    
//    
//    var screenWidth: CGFloat {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first else {
//            return 0
//        }
//        return window.screen.bounds.width
//    }
//    
//    var body: some View {
//        VStack(spacing : 0){
//            VStack(spacing: 0) {
//                // TodoListAppBar
//                HStack(spacing : 0){
//                    Button {
//                        onDismiss()
//                    } label: {
//                        Image(systemName: "arrow.backward")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30, height: 30)
//                    }
//                    Spacer()
//                    Image(systemName: "ellipsis")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 30, height: 30)
//                        .rotationEffect(.degrees(90))
//                }
//                .padding(.horizontal, 30)
//                .padding(.top, 10)
//                .padding(.bottom, 25)
//                // TodoListHeader
//                VStack (alignment: .leading, spacing: 20){
//                    // Title
//                    Text(card.title)
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .padding(.leading, 30)
//                        .padding(.bottom, 5)
//                    // ProgressBar
////                    DetailProgressBar()
//                }
//                .padding(.bottom, 20)
//            }
//            .background(card.color)
//            .matchedGeometryEffect(id: "background-\(card.id)", in: namespace)
//            // TodoListBody
//            VStack (alignment: .leading, spacing: 0){
//                Text("やることリスト")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.bottom, 20)
//                // todoList
//                ScrollView {
//                    MultiCheckBox(selection: $dateModel.selection ,options: Option.allCases)
//                }
//                .frame(maxHeight: .infinity)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//            .padding(.top, 20)
//            .background(Color.gray.gradient)
//            
//            // FloatingButton
//            .overlay(alignment: .bottom) {
//                Button {
//                    showAlert.toggle()
//                } label: {
//                    Text("完了")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .foregroundStyle(.white)
//                        .scaleEffect(1.02)
//                        .frame(width: screenWidth - 60,height: 50)
//                        .background(Color.black)
//                        .clipShape(RoundedRectangle(cornerRadius: 40))
//                        .contentShape(.rect)
//                }
//                .padding(.bottom, 78)
//                .alert(isPresented: $showAlert) {
//                    /// alertのdialogの見た目
//                    VStack {
//                        Text("aaa")
//                        Button("戻る") {
//                            showAlert.toggle()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                onDismiss()
//                            }
//                        }
//                    }
//                    /// alertの背景
//                } background: {
//                    Rectangle()
//                        .fill(.primary.opacity(0.35))
//                }
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}

//#Preview {
//    @Namespace var previewNamespace
//    TodoListView(
//        card: CardData(title: "漫画1巻", color: .white),
//        namespace: previewNamespace,
//        onDismiss: {
//            print("aaa")
//        }
//    )
//    .environmentObject(DateModel())
//}
