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

/// `Button` provides the functionality for a stand-alone button
/// or within a panel.  The button may use a specified size or
/// can automatically calculate the optimal size based upon the
/// text.  A button should respond to an EntityMouseClick event.
public class Button : TextLabel {

    private static let buttonDownOffset = Point(x:2, y:2)

    // ********************************************************************************
    // Functions for internal use
    // ********************************************************************************
    
    // ********************************************************************************
    // API FOLLOWS
    // ********************************************************************************

    // ********************************************************************************
    // API FOLLOWS
    // These functions may be over-ridden by descendant classes
    // ********************************************************************************
    
    /// Based upon the most recent size available and the current
    /// position, returns the rect to be used for rendering.
    open override func currentRect() -> Rect? {
        // Offset the currentRect if the button is pressed
        if var rect = super.currentRect() {
            if isMouseOver && isMouseDown {
                rect.topLeft += Self.buttonDownOffset
            }
            return rect
        } else {
            return nil
        }
    }

    /// Renders the `Button`
    open override func render(canvas:Canvas) {
        // Determine metrics if required
        if textMetric.currentMetrics == nil && textMetric.isReady {
            canvas.render(textMetric)
        } 

        // Render button if size is known
        if let rect = currentRect() {
            let backgroundFillStyle = isMouseOver ? controlStyle.backgroundHoverFillStyle : controlStyle.backgroundFillStyle
            let roundingRadius = Int(controlStyle.roundingPercentage * Double(min(rect.size.width, rect.size.height)))
            let path = Path(rect:rect, radius:roundingRadius, fillMode:.fillAndStroke)
            text.location = rect.center
            canvas.render(controlStyle.foregroundStrokeStyle, backgroundFillStyle, path)
            canvas.render(controlStyle.textStrokeStyle, controlStyle.textFillStyle, text)
        }

        // Update cursor style if required
        if isMouseOver && (cursorStyle != controlStyle.hoverCursorStyle) {
            cursorStyle = controlStyle.hoverCursorStyle
            canvas.render(CursorStyle(style: cursorStyle))
        }
        if !isMouseOver && (cursorStyle != controlStyle.normalCursorStyle) {
            cursorStyle = controlStyle.normalCursorStyle
            canvas.render(CursorStyle(style: cursorStyle))
        }
        
    }
    
}
