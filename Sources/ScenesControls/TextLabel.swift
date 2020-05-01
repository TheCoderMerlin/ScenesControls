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

/// `TextLabel` provides the functionality for a stand-alone text 
/// label or within a panel.  The label may use a specified size
/// or can automatically calculate the optimal size based upon the
/// text.  A label may optionally respond to an EntityMouseClick
/// event.
public class TextLabel : Control {

    public let text : Text
    public let textMetric : TextMetric

    private var needNewClipPath : Bool

    /// Initializes a new `TextLabel`
    /// - Parameters:
    ///   - name: The unique name of this entity.  While it's very useful for
    ///           debugging purposes to provide a meaningful name, it's not
    ///           required.
    ///   - labelString: The text to be displayed in the control.
    ///   - clickHandler: An optional handler to respond to EntityMouseClick
    ///           events.
    ///   - topLeft: The topLeft corner point at which to locate this control.
    ///   - fixedSize: The size of this control.  If nil, the size will be
    ///           calculated.
    ///   - controlStyle: The stylistic elements to be used in rendering this
    ///           control.
    public init(name:String?=nil, 
                labelString:String, clickHandler:ClickHandler?=nil,
                topLeft:Point=Point.zero, fixedSize:Size?=nil,
                controlStyle:ControlStyle=ControlStyle()) {

        // Create the text object
        // The alignment and baseline are always centered so the text is in the
        // center of the button
        text = Text(location: topLeft, text: labelString, fillMode:controlStyle.textFillMode)
        text.font = controlStyle.font
        text.alignment = .center
        text.baseline = .middle

        // Create the textMetric object
        textMetric = TextMetric(fromText:text)

        // We'll need a newClipPath if fixedSize is specified
        needNewClipPath = fixedSize != nil
        
        super.init(name:name, 
                   clickHandler:clickHandler,
                   topLeft:topLeft, fixedSize:fixedSize,
                   controlStyle:controlStyle)
    }


    open override func sizeChanged() {
        // If the size has changed and we have a fixed size, we'll need a new clipPath
        needNewClipPath = fixedSize != nil
    }

    open override func topLeftChanged() {
        // If the topLeft has changed and we have a fixed size, we'll need a new clipPath
        needNewClipPath = fixedSize != nil
    }

    
    // ********************************************************************************
    // API FOLLOWS
    // ********************************************************************************

    /// The text to be displayed in the `TextLabel`
    /// Altering this text will cause a recalculation of size based
    /// upon the new text.  If *specifiedSize* is nil, the `TextLabel`
    /// will be resized.
    public var labelString : String {
        get {
            return text.text
        }
        set {
            text.text = newValue
            textMetric.text = newValue
            currentCalculatedSize = nil
        }
    }
    
    // ********************************************************************************
    // API FOLLOWS
    // These functions may be over-ridden by descendant classes
    // ********************************************************************************

    /// Performs any required setup.
    /// The default invokes the *setup()* of the superclass, and then
    /// sets up the textMetric.
    open override func setup(canvasSize:Size, canvas:Canvas) {
        super.setup(canvasSize:canvasSize, canvas:canvas)
        
        canvas.setup(textMetric)
    }

    /// Calculates a new rect based upon the size of the text.
    open func calculateRect() -> Rect? {
        if let metrics = textMetric.currentMetrics {
            var rect = metrics.fontBoundingBox()
            rect.inflate(by: controlStyle.padding)
            rect.topLeft = topLeft
            return rect
        } else {
            return nil
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

    /// If necessary, invokes *calculateRect()* to calculate and
    /// update the *currentCalculatedSize*.
    open override func calculate(canvasSize:Size) {
        super.calculate(canvasSize:canvasSize)
        
        // If we don't have a size, we calculate it here
        if currentCalculatedSize == nil {
            if let rect = calculateRect() {
                currentCalculatedSize = rect.size
            }
        }

        // If we have a fixed size then it's not calculated based upon text size
        // As a consequence, the text may exceed the bounds of the object
        // We therefore apply a clipping path
        if needNewClipPath { 
            if let rect = currentRect() {
                let path = Path(rect:rect)
                setClipPath(clipPath:ClipPath(path:path))
            }
            needNewClipPath = false
        } 
    }

    /// Renders the `TextLabel`
    /// Also requests updated text metrics if the text has changed.
    open override func render(canvas:Canvas) {
        // Determine metrics if required
        if textMetric.currentMetrics == nil && textMetric.isReady {
            canvas.render(textMetric)
        } 

        // Render label if size is known
        if let rect = currentRect() {
            let rectangle = Rectangle(rect:rect, fillMode:.fillAndStroke)
            if controlStyle.labelsDisplayEnclosingRect {
                canvas.render(controlStyle.foregroundStrokeStyle, controlStyle.backgroundFillStyle, rectangle)
            }
            text.location = rect.center
            canvas.render(controlStyle.textStrokeStyle, controlStyle.textFillStyle, text)
        }
        
    }
}
