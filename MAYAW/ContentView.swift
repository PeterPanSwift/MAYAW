import SwiftUI

struct ContentView: View {
    var body: some View {
        MAYAWLogo()
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.12, green: 0.14, blue: 0.18))
    }
}

/// 以內建 Capsule 組合筆畫、Rectangle 裁齊上下緣，不依賴字型或圖片。
struct MAYAWLogo: View {
    private static let designSize = CGSize(width: 512, height: 144)
    private let gold = Color(red: 0.73, green: 0.65, blue: 0.43)
    private let ink = Color(red: 0.075, green: 0.09, blue: 0.11)

    var body: some View {
        GeometryReader { geometry in
            let scale = min(
                geometry.size.width / Self.designSize.width,
                geometry.size.height / Self.designSize.height
            )

            Self.lettering
                .fill(ink)
                .overlay {
                    Self.lettering
                        .stroke(gold, style: StrokeStyle(lineWidth: 4, lineJoin: .miter))
                }
                .frame(width: Self.designSize.width, height: Self.designSize.height)
                .scaleEffect(scale)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .aspectRatio(Self.designSize, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("MAYAW")
    }

    // 先合併筆畫再描邊，讓交接處保持中空粗體字的連續外框。
    private static let lettering: AnyShape = {
        let letters = letterM
            .union(letterA.offset(x: 96, y: 0))
            .union(letterY.offset(x: 183, y: 0))
            .union(letterA.offset(x: 263, y: 0))
            .union(letterW.offset(x: 358, y: 0))

        return AnyShape(
            letters
                .intersection(Rectangle().size(width: 472, height: 96))
                // 水平剪切讓字體右傾，同時維持上下緣水平。
                .transform(CGAffineTransform(a: 1, b: 0, c: -0.19, d: 1, tx: 28, ty: 24))
        )
    }()

    private static var letterM: some Shape {
        bar(from: CGPoint(x: 12, y: 0), to: CGPoint(x: 12, y: 96), width: 23)
            .union(bar(from: CGPoint(x: 74, y: 0), to: CGPoint(x: 74, y: 96), width: 23))
            .union(bar(from: CGPoint(x: 12, y: 0), to: CGPoint(x: 43, y: 47), width: 23))
            .union(bar(from: CGPoint(x: 43, y: 47), to: CGPoint(x: 74, y: 0), width: 23))
    }

    private static var letterA: some Shape {
        bar(from: CGPoint(x: 12, y: 96), to: CGPoint(x: 43, y: 0), width: 23)
            .union(bar(from: CGPoint(x: 43, y: 0), to: CGPoint(x: 74, y: 96), width: 23))
            .union(bar(from: CGPoint(x: 24, y: 68), to: CGPoint(x: 63, y: 68), width: 18))
    }

    private static var letterY: some Shape {
        bar(from: CGPoint(x: 9, y: 0), to: CGPoint(x: 39, y: 47), width: 23)
            .union(bar(from: CGPoint(x: 39, y: 47), to: CGPoint(x: 69, y: 0), width: 23))
            .union(bar(from: CGPoint(x: 39, y: 47), to: CGPoint(x: 39, y: 96), width: 24))
    }

    private static var letterW: some Shape {
        bar(from: CGPoint(x: 10, y: 0), to: CGPoint(x: 28, y: 96), width: 23)
            .union(bar(from: CGPoint(x: 28, y: 96), to: CGPoint(x: 55, y: 39), width: 23))
            .union(bar(from: CGPoint(x: 55, y: 39), to: CGPoint(x: 82, y: 96), width: 23))
            .union(bar(from: CGPoint(x: 82, y: 96), to: CGPoint(x: 100, y: 0), width: 23))
    }

    /// 將膠囊形旋轉並平移成一筆；圓端讓斜筆畫交接處不會產生凸角。
    private static func bar(from start: CGPoint, to end: CGPoint, width: CGFloat) -> some Shape {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let length = hypot(dx, dy)
        let cosine = dx / length
        let sine = dy / length

        return Capsule()
            .size(width: length + width, height: width)
            .transform(CGAffineTransform(
                a: cosine,
                b: sine,
                c: -sine,
                d: cosine,
                tx: start.x - cosine * width / 2 + sine * width / 2,
                ty: start.y - sine * width / 2 - cosine * width / 2
            ))
    }
}

#Preview {
    ContentView()
}
