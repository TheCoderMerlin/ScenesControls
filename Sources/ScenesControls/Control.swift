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

/// The base class for `Control`s which provides default functionality.
/// 1. Register/unregisters handlers
/// 1. Handles EntityMouseEnter/EntityMouseLeave by setting *isMouseOver*
/// 2. Handles EntityMouseDown/MouseUp by setting *isMouseDown*
/// 3. Handles EntityMouseClick by relaying click to handler (if specified)
public class Control : ContainableRenderableEntity,
                       EntityMouseEnterHandler, EntityMouseLeaveHandler,
                       EntityMouseDownHandler, MouseUpHandler,
                       EntityMouseClickHandler
{
    /// Type of handler for Clicks
    public typealias ClickHandler = (_ control:Control, _ localLocation:Point) -> Void

    /// Stores the handler to be used when a click event occurs
    public var clickHandler : ClickHandler?

    /// Stores the controlStyle to used for this control
    public let controlStyle : ControlStyle
    
    /// Indicates if the mouse is currently over this entity
    /// Set automatically by EntityMouseEnter/EntityMouseLeave
    public private(set) var isMouseOver = false

    /// Indicates if the mouse was pressed down over this entity
    /// and the mouse button is still down
    /// Set automatically by EntityMouseDown/MouseUp
    public private(set) var isMouseDown = false

    /// The current style of the cursor
    public var cursorStyle : CursorStyle.Style

    // ********************************************************************************
    // Functions for internal use
    // ********************************************************************************
    
    // ********************************************************************************
    // API FOLLOWS
    // ********************************************************************************
    public init(name:String?=nil, 
                clickHandler:ClickHandler?=nil,
                topLeft:Point=Point.zero, fixedSize:Size?=nil,
                controlStyle:ControlStyle = ControlStyle()) {
        self.clickHandler = clickHandler
        self.controlStyle = controlStyle
        self.cursorStyle = controlStyle.normalCursorStyle
        super.init(name:name, 
                   topLeft:topLeft, fixedSize:fixedSize)
    }


    // ********************************************************************************
    // API FOLLOWS
    // These functions may be over-ridden by descendant classes
    // ********************************************************************************

    /// Setup
    /// The default implementation registers all default event handlers
    open override func setup(canvasSize:Size, canvas:Canvas) {
        dispatcher.registerEntityMouseEnterHandler(handler:self)
        dispatcher.registerEntityMouseLeaveHandler(handler:self)
        dispatcher.registerEntityMouseDownHandler(handler:self)
        dispatcher.registerMouseUpHandler(handler:self)
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }


    /// Teardown
    /// The default implementation unregisters all default event handlers
    open override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
        dispatcher.unregisterMouseUpHandler(handler:self)
        dispatcher.unregisterEntityMouseDownHandler(handler:self)
        dispatcher.unregisterEntityMouseLeaveHandler(handler:self)
        dispatcher.unregisterEntityMouseEnterHandler(handler:self)
    }

    /// Returns the bounding `Rect` for this control
    /// The default implementation relies on the specified *topLeft*
    /// and *mostRecentSize*.  If the *mostRecentSize* is not available,
    /// returns Rect.zero.
    open override func boundingRect() -> Rect {
        if let size = mostRecentSize {
            return Rect(topLeft:topLeft, size:size)
        } else {
            return Rect.zero
        }
    }
    
    /// EventHandler for EntityMouseEnter
    /// The default implmentation sets *isMouseOver* to true.
    open func onEntityMouseEnter(globalLocation:Point) {
        isMouseOver = true
    }

    /// EventHandler for EntityMouseLeave
    /// The default implmentation sets *isMouseOver* to false.
    open func onEntityMouseLeave(globalLocation:Point) {
        isMouseOver = false
    }

    /// EventHandler for EntityMouseDown
    /// The default implmentation sets *isMouseDown* to true.
    open func onEntityMouseDown(globalLocation:Point) {
        isMouseDown = true
    }

    /// EventHandler for MouseUp
    /// The default implmentation sets *isMouseDown* to false.
    open func onMouseUp(globalLocation:Point) {
        isMouseDown = false
    }

    /// EventHandler for EntityMouseClick
    /// The default implementation invokes the clickHandler
    open func onEntityMouseClick(globalLocation:Point) {
        if let clickHandler = clickHandler {
            let localLocation = local(fromGlobal:globalLocation)
            clickHandler(self, localLocation)
        }
    }
    
    /// renders this `Control`
    /// The default implementation does nothing
    open override func render(canvas:Canvas) {
    }
}
