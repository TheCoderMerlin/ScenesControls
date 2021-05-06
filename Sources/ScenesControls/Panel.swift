/*
ScenesControls provides a Swift object library with support for common
controls.  ScenesControls runs on top of Scenes and IGIS.
Copyright (C) 2020-2021 Tango Golf Digital, LLC
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
import Scenes

/// This class provides a rendered container for controls,
/// visually grouping them together and providing the ability
/// to easily reposition and layout the controls.
public class Panel : ControlContainer {

    /// Determines the `LayoutStyle` to be used for this panel.
    public enum LayoutStyle {
        /// All controls are uniformly sized in a single row.
        case uniformRow
        /// All controls are uniformly sized in a single column.
        case uniformColumn

        /// All controls are placed in a single row with given vertical alignment.
        case row(alignment:VerticalAlignment)
        /// All controls are placed in a single column with given horizontal alignment.
        case column(alignment:HorizontalAlignment)

        /// All controls are placed in a single row aligned to the top.
        public static var row : LayoutStyle {
            return .row(alignment:.top)
        }

        /// All controls are placed in a single column aligned to the left.
        public static var column : LayoutStyle {
            return .column(alignment:.left)
        }
    }

    /// Specifies the layoutStyle to be used for this panel.
    public var layoutStyle : LayoutStyle {
        didSet {
            // Force a recalculation to occur
            currentCalculatedSize = nil
        }
    }

    public init(name:String?=nil, 
                topLeft:Point=Point.zero, fixedSize:Size?=nil,
                layoutStyle:LayoutStyle = .uniformRow,
                controlStyle:ControlStyle = ControlStyle()) {
        self.layoutStyle = layoutStyle
        super.init(name:name, 
                   topLeft:topLeft, fixedSize:fixedSize,
                   controlStyle:controlStyle)
    }

    /// Recalculates the size of this panel using the specified layout.
    /// If it is not possible to recalculate the size (for example, because
    /// children don't yet have a *currentCalculatedSize* the request is ignored.
    open override func calculateSize() -> Size? {
        if var rects = childRects {
            // calculate sourceRect for children
            let targetWidth = Layout.property(attribute:.maxWidth, childRects:rects)
            let targetHeight = Layout.property(attribute:.maxHeight, childRects:rects)
            let sourceRect = Rect(topLeft:topLeft + Point(x:controlStyle.padding, y:controlStyle.padding),
                                  size:Size(width:targetWidth, height:targetHeight))
        
            // apply layout to child rects
            switch layoutStyle {
            case .uniformRow:
                let alignment = Alignment(horizontal:.stretch, vertical:.stretch)
                rects = alignment.apply(toRects:rects, sourceRect:sourceRect)
                rects = Layout.apply(rule:.distributeHorizontally(left:sourceRect.left, spacing:controlStyle.padding), childRects:rects)
            case .uniformColumn:
                let alignment = Alignment(horizontal:.stretch, vertical:.stretch)
                rects = alignment.apply(toRects:rects, sourceRect:sourceRect)
                rects = Layout.apply(rule:.distributeVertically(top:sourceRect.top, spacing:controlStyle.padding), childRects:rects)
            case .row(let alignment):
                rects = alignment.apply(toRects:rects, sourceRect:sourceRect)
                rects = Layout.apply(rule:.distributeHorizontally(left:sourceRect.left, spacing:controlStyle.padding), childRects:rects)
            case .column(let alignment):
                rects = alignment.apply(toRects:rects, sourceRect:sourceRect)
                rects = Layout.apply(rule:.distributeVertically(top:sourceRect.top, spacing:controlStyle.padding), childRects:rects)
            }

            // Apply the new rects to the entities
            childRects = rects

            // Set our own size
            let width  = Layout.property(attribute:.fullWidth, childRects:rects) + controlStyle.padding * 2
            let height = Layout.property(attribute:.fullHeight, childRects:rects) + controlStyle.padding * 2
            return Size(width:width, height:height)
        }
        
        return nil
    }

    /// Renders the panel.  Contained controls are responsible for rendering themselves.
    open override func render(canvas:Canvas) {
        // Render if panel size is known
        if let rect = currentRect {
            let rectangle = Rectangle(rect:rect, fillMode:.fillAndStroke)
            canvas.render(controlStyle.panelStrokeStyle, controlStyle.panelFillStyle, rectangle)
        }
    }
}
