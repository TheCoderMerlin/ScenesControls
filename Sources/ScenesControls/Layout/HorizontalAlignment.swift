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

/// An alignment position along the horizontal axis.
public enum HorizontalAlignment {
    case left
    case center
    case right
    case stretch

    internal func apply(toRects childRects:[Rect], sourceRect:Rect) -> [Rect] {
        switch self {
        case .left:
            return Layout.apply(rule:.alignLefts(left:sourceRect.left), childRects:childRects)
        case .center:
            return Layout.apply(rule:.alignCenterX(centerX:sourceRect.centerX), childRects:childRects)
        case .right:
            return Layout.apply(rule:.alignRights(right:sourceRect.right), childRects:childRects)
        case .stretch:
            var rects = childRects
            rects = Layout.apply(rule:.alignLefts(left:sourceRect.left), childRects:rects)
            rects = Layout.apply(rule:.alignWidths(width:sourceRect.width), childRects:rects)
            return rects
        }
    }
}
