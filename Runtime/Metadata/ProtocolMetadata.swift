// MIT License
//
// Copyright (c) 2017 Wesley Wickwire
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation



struct ProtocolMetadata: MetadataType, TypeInfoConvertible {
    
    var type: Any.Type
    var metadata: UnsafeMutablePointer<ProtocolMetadataLayout>
    var base: UnsafeMutablePointer<Int>
    var protocolDescriptor: UnsafeMutablePointer<ProtocolDescriptor>
    
    init(type: Any.Type) {
        self.type = type
        base = metadataPointer(type: type)
        metadata = base.advanced(by: -1).raw.assumingMemoryBound(to: ProtocolMetadataLayout.self)
        protocolDescriptor = metadata.pointee.protocolDescriptorVector
    }
    
    mutating func mangledName() -> String {
        return String(cString: protocolDescriptor.pointee.mangledName)
    }
    
    mutating func toTypeInfo() -> TypeInfo {
        return TypeInfo(
            kind: .protocol,
            name: "\(type)",
            type: type,
            mangledName: mangledName(),
            properties: [],
            inheritance: [],
            genericTypes: [],
            numberOfProperties: 0,
            numberOfGenericTypes: 0,
            size: size,
            alignment: alignment,
            stride: stride)
    }
}