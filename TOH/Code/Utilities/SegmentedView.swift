//
//  SegmentedView.swift
//  TOH
//
//  Created by Alia on 2025/2/25.
//

import SwiftUI
/*
struct SegmentedView: View {

    let segments: [String]
    @Binding var selected: String
    @Namespace var name

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Button {
                    selected = segment
                } label: {
                    VStack {
                        Text(segment)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(selected == segment ? .green : Color(uiColor: .systemGray))
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 4)
                            if selected == segment {
                                Capsule()
                                    .fill(Color.green)
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                }
            }
        }
    }
}

/*
#Preview {
    SegmentedView(segments: ["CASTLE", "RAMEN"], selected: $currentSegment)
}
*/
*/

struct CustomSegmentedControl: View {
    @Binding var selected: Int
    @State private var proxy: ScrollViewProxy?
    @State private var horizontalScrollWidth: CGFloat = 0
    @Namespace var name

    let options: [(option: String, contentView: AnyView)]
    
    var body: some View {
        VStack {
            SegmentedControlOptionsView
                .frame(height: 80)
            
            SegmentedContentView
        }
    }
    
    private var SegmentedControlOptionsView: some View {
        LazyHStack(spacing: 20) {
            ForEach(Array(zip(options.indices, options)), id: \.0) { index, option in
                Button {
                    withAnimation(.default) {
                        selected = index
                        proxy?.scrollTo(index)
                    }
                } label: {
                    VStack(spacing: 5) {
                        Text(option.option)
                            .foregroundStyle(Color.black)
                        ZStack {
                            Capsule()
                                .fill(.clear)
                                .frame(height: 4)
                            if selected == index {
                                Capsule()
                                    .fill(.myGreen2)
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var SegmentedContentView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(zip(options.indices, options)), id: \.0) { index, option in
                        option.contentView
                            .id(index)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                        .onAppear {
                            horizontalScrollWidth = geometry.size.width
                        }
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: { value in
                    var page = 0
                    let xOffset = abs(value.x)
                    let widthForEachSegmentedView = horizontalScrollWidth / CGFloat(options.count)
                    if horizontalScrollWidth != 0 {
                        let offsetRelation = xOffset / widthForEachSegmentedView
                        page = Int(offsetRelation.rounded(.toNearestOrEven))
                    }
                    
                    withAnimation(.easeOut) {
                        selected = page
                    }
                })
            }
            .coordinateSpace(name: "scroll")
            .onAppear {
                proxy = scrollProxy
            }
        }
    }
    
    
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
/*
#Preview {
    VStack{
        CustomSegmentedControl(selected: $selected, options: [
                ("View 1", AnyView(FavoritesView())),
                ("This tab is important", AnyView(CastleView())),
                ("View 3", AnyView(Text("WELCOME TO THE THIRD TAB, IN HERE YOUR ARE GOING TO FIND... NOTHING")))
            ])
            .frame(maxWidth: .infinity)
    }
    
}
*/

