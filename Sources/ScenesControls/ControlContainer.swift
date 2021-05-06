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

/// The base class for `ControlContainer`s which provides default styling
/// and size calculation functionality.
public class ControlContainer : RenderableEntityContainer {
    /// Stores the controlStyle to used for this control.
    public let controlStyle : ControlStyle

    /// When the topLeft changes, force a recalculation to occur.
    open override func topLeftChanged() {
        currentCalculatedSize = nil
    }

    /// When the size changes, force a recalculation to occur IF there is
    /// an owning container (otherwise it was internally set and should
    /// already be handled).
    open override func sizeChanged() {
        if owningContainer == nil {
            currentCalculatedSize = nil
        }
    }
    
    public init(name:String?=nil,
                topLeft:Point=Point.zero, fixedSize:Size?=nil,
                controlStyle:ControlStyle = ControlStyle()) {
        self.controlStyle = controlStyle
        super.init(name:name,
                   topLeft:topLeft, fixedSize:fixedSize)
    }
}
