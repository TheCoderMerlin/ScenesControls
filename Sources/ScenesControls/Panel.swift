/*
ScenesControls provides a Swift object library with support for common
controls.  ScenesControls runs on top of Scenes and IGIS.
Copyright (C) 2020 Tango Golf Digital, LLC
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
public class Panel : RenderableEntityContainer {

    /// Determines the `LayoutStyle` to be used for this panel
    public enum LayoutStyle {
        /// All controls are uniformly sized in a single row
        case uniformRow
        /// All controls are uniformly sized in a single column
        case uniformColumn
    }
    
    /// Stores the controlStyle to used for this control
    public let controlStyle : ControlStyle

    /// Specifies the layoutStyle to be used for this panel
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
        self.controlStyle = controlStyle
        super.init(name:name, 
                   topLeft:topLeft, fixedSize:fixedSize)
    }

    /// Recalculates the size of this panel using the specified layout
    /// If it is not possible to recalculate the size (for example, because
    /// children don't yet have a *currentCalculatedSize* the request is ignored
    open override func recalculateSize() {
        if var rects = childRects {
            let targetWidth = Layout.property(attribute:.maxWidth, childRects:rects)
            let targetHeight = Layout.property(attribute:.maxHeight, childRects:rects)

            switch layoutStyle {
            case .uniformRow:
                rects = Layout.apply(rule:.alignTops(top:topLeft.y + controlStyle.padding), childRects:rects)
                rects = Layout.apply(rule:.alignWidths(width:targetWidth), childRects:rects)
                rects = Layout.apply(rule:.alignHeights(height:targetHeight), childRects:rects)
                rects = Layout.apply(rule:.distributeHorizontally(left:topLeft.x + controlStyle.padding, padding:controlStyle.padding), childRects:rects)
            case .uniformColumn:
                rects = Layout.apply(rule:.alignLefts(left:topLeft.x + controlStyle.padding), childRects:rects)
                rects = Layout.apply(rule:.alignWidths(width:targetWidth), childRects:rects)
                rects = Layout.apply(rule:.alignHeights(height:targetHeight), childRects:rects)
                rects = Layout.apply(rule:.distributeVertically(top:topLeft.y + controlStyle.padding, padding:controlStyle.padding), childRects:rects)
            }
            
            // Apply the new rects to the entities
            childRects = rects

            // Set our own size
            let width  = Layout.property(attribute:.fullWidth, childRects:rects) + controlStyle.padding * 2
            let height = Layout.property(attribute:.fullHeight, childRects:rects) + controlStyle.padding * 2
            currentCalculatedSize = Size(width:width, height:height)
        }
    }

    /// Based upon the most recent size available and the current
    /// position, returns the rect to be used for rendering.
    open func currentRect() -> Rect? {
        if let size = mostRecentSize {
            return Rect(topLeft:topLeft, size:size)
        } else {
            return nil
        }
    }


    /// If necessary, invokes *recalculateSize()* to calculate and
    /// update the *currentCalculatedSize*.
    open override func calculate(canvasSize:Size) {
        super.calculate(canvasSize:canvasSize)

        // If we don't have a size, we calculate it here
        if currentCalculatedSize == nil {
            recalculateSize()
        }
    }

    /// Renders the panel.  Contained controls are responsible for rendering themselves.
    open override func render(canvas:Canvas) {
        // Render if panel size is known
        if let rect = currentRect() {
            let rectangle = Rectangle(rect:rect, fillMode:.fillAndStroke)
            canvas.render(controlStyle.panelStrokeStyle, controlStyle.panelFillStyle, rectangle)
        }
        
    }

}


