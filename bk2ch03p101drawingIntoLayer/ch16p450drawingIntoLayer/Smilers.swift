

import UIKit

// Big change in iOS 10: CALayerDelegate is a real protocol!

class Smiler: NSObject, CALayerDelegate {
    // ham nay cho phep su dung context de draw content to layer context
    // su dung core graphics methods
    func draw(_ layer: CALayer, in ctx: CGContext) {
        UIGraphicsPushContext(ctx) // set ctx become to current graphic context

        // Context giống nhau trong mọi lần refresh
        print(Unmanaged.passUnretained(ctx).toOpaque())
        print(Unmanaged.passUnretained(layer).toOpaque())

        // Xuất hiện hiện tượng khi refresh liên tục content của layer
        // thì random text vẽ lần trước ko bị clear đi do đó random text
        // của lần vẽ sau đè lên.
        // Solution: vì là same context lên ta cần clear context trước khi
        // thực hiện bất kỳ drawing nào

        ctx.clear(layer.bounds)                        // Working
//        ctx.clear(ctx.boundingBoxOfClipPath)      // Working
//        ctx.clear(ctx.boundingBoxOfPath)               // Not working

//        [[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"smiley")!.draw(at: .zero)

        // add random text in context
        let random = Int.random(in: 0...100)
        let text = "\(random)" as NSString
        text.draw(at: CGPoint(30, 30), withAttributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)])

        UIGraphicsPopContext()
        print("\(#function)")
        print(layer.contentsGravity)
    }
}

class Smiler2: NSObject, CALayerDelegate {
    // Tai sao ham display goi truoc
    // Hinh nhu khi xuat hien ham display
    // thi ham draw(_:in) khong duoc goi nua
    func display(_ layer: CALayer) {
        layer.contents = UIImage(named:"smiley")!.cgImage
        print("\(#function)")
        print(layer.contentsGravity)
    }
}

class SmilerLayer:CALayer {
    override func draw(in ctx: CGContext) {
        // self.backgroundColor = UIColor.red.withAlphaComponent(0.5).cgColor
        self.backgroundColor = UIColor.red.cgColor

        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"smiley")!.draw(at: .zero)
        ctx.clear(CGRect(0,0,30,30)) // showing that clear "paints with the bg color"
        UIGraphicsPopContext()
        print("\(#function)")
        print(self.contentsGravity)
    }
}

class SmilerLayer2:CALayer {
    override func display() {
        self.contents = UIImage(named:"smiley")!.cgImage
        print("\(#function)")
        print(self.contentsGravity)
    }
}
