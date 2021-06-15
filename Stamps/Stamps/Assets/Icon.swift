//
//  Icon.swift
//  Stamps
//
//  Created by Inti Albuquerque on 15/06/21.
//

import SwiftUI

struct Icon: View {
    let name: String
    let alignment: Alignment
    let size: CGFloat
    
    init(_ name: String, alignment: Alignment = .center, size: CGFloat = 24) {
        self.name = name
        self.alignment = alignment
        self.size = size
    }
    
    var body: some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .frame(size: size, alignment: alignment)
            .foregroundColor(.icon)
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon("email")
    }
}

extension View {
    func frame(size: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }
}
