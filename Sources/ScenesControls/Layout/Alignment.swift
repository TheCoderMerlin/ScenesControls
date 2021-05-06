/*
ScenesControls provides a Swift object library with support for common
controls.  ScenesControls runs on top of Scenes and IGIS.
Copyright (C) 2021 Tango Golf Digital, LLC
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import Igis

/// An alignment in both axis.
public struct Alignment {
    /// The alignment on the horizontal axis.
    public var horizontal : HorizontalAlignment
    
    /// The alignment on the vertical axis.
    public var vertical : VerticalAlignment

    /// Creates a new `Alignment` with the given horizontal and vertical alignments.
    /// - Parameters:
    ///   - horizontal: The alignment on the horizontal axis.
    ///   - vertical: The alignment on the vertical axis.
    public init(horizontal:HorizontalAlignment, vertical:VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public static let topLeft = Alignment(horizontal:.left, vertical:.top)
    public static let top = Alignment(horizontal:.center, vertical:.top)
    public static let topRight = Alignment(horizontal:.right, vertical:.top)
    
    public static let left = Alignment(horizontal:.left, vertical:.center)
    public static let center = Alignment(horizontal:.center, vertical:.center)
    public static let right = Alignment(horizontal:.right, vertical:.center)

    public static let bottomLeft = Alignment(horizontal:.left, vertical:.bottom)
    public static let bottom = Alignment(horizontal:.center, vertical:.bottom)
    public static let bottomRight = Alignment(horizontal:.right, vertical:.bottom)

    internal func apply(toRects childRects:[Rect], sourceRect:Rect) -> [Rect] {
        var rects = childRects
        rects = horizontal.apply(toRects:rects, sourceRect:sourceRect)
        rects = vertical.apply(toRects:rects, sourceRect:sourceRect)
        return rects
    }
}
