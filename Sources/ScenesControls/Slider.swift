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
import Scenes

public class Slider : Control, EntityMouseDragHandler {

    public let range : ClosedRange<Double>
    public let interval : Double?

    private var _value : Double
    
    public init(name:String?=nil,
                range:ClosedRange<Double>, interval:Double?=nil,
                clickHandler:ClickHandler?=nil,
                topLeft:Point=Point.zero, fixedSize:Size?=nil,
                controlStyle:ControlStyle=ControlStyle()) {
        self.range = range
        self.interval = interval
        self._value = range.lowerBound
        
        super.init(name:name,
                   clickHandler:clickHandler,
                   topLeft:topLeft, fixedSize:fixedSize,
                   controlStyle:controlStyle)
    }

    internal func setValue(from globalLocation:Point) {
        let rangeDelta = range.upperBound - range.lowerBound
        let localLocation = local(fromGlobal:globalLocation)
        let normal = Double(localLocation.x) / Double(boundingRect().inflated(by:-controlStyle.padding).width)
        value = (normal * rangeDelta) + range.lowerBound
    }

    public var value : Double {
        get {
            return _value
        }
        set {
            var clampedValue = min(max(newValue, range.lowerBound), range.upperBound)
            if let interval = interval {
                let multiple = (clampedValue / interval).rounded()
                clampedValue = multiple * interval
            }
            _value = clampedValue
        }
    }
    
    open override func calculateSize() -> Size? {
        return Size.zero
    }

    open override func setup(canvasSize:Size, canvas:Canvas) {
        super.setup(canvasSize:canvasSize, canvas:canvas)
        dispatcher.registerEntityMouseDragHandler(handler:self)
    }

    open override func teardown() {
        dispatcher.unregisterEntityMouseDragHandler(handler:self)
        super.teardown()
    }

    open override func onEntityMouseClick(globalLocation:Point) {
        setValue(from:globalLocation)
        super.onEntityMouseClick(globalLocation:globalLocation)
    }

    open func onEntityMouseDrag(globalLocation:Point, movement:Point) {
        setValue(from:globalLocation)
    }

    open override func render(canvas:Canvas) {
        // Render slider if size is known
        if var rect = currentRect {
            rect.inflate(by:-controlStyle.padding)
            rect.width -= rect.height
            var thumbRect = Rect(topLeft:rect.topLeft, size:Size(width:rect.height, height:rect.height))
            thumbRect.topLeft.x += Int(((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * Double(rect.width))
            let thumb = Path(rect:thumbRect, radius:Int(Double(thumbRect.width) * controlStyle.roundingPercentage), fillMode:.fillAndStroke)
            let line = Lines(from:Point(x:rect.left + rect.height / 2, y:rect.centerY), to:Point(x:rect.right + rect.height / 2, y:rect.centerY))
 
            canvas.render(controlStyle.foregroundStrokeStyle, controlStyle.backgroundFillStyle, line, thumb)
        }
    }
}
