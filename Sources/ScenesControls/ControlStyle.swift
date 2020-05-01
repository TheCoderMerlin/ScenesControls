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
  
/// This struct provides information for styling controls.
/// It also provides static variables which can be used for establishing
/// global defaults.
/// The struct is copied when used so the original may be altered
/// prior to the next use without affecting previous controls.
public struct ControlStyle {

    // Text
    public static var defaultFont                  = "20px Arial"
    public static var defaultTextFillMode          = FillMode.fill
    public static var defaultTextStrokeStyle       = StrokeStyle(color:Color(.black))
    public static var defaultTextFillStyle         = FillStyle(color:Color(.white))

    // Foreground and background styles
    public static var defaultForegroundStrokeStyle    = StrokeStyle(color:Color(red:0x9F, green:0xB4, blue:0xF2))
    public static var defaultBackgroundFillStyle      = FillStyle(color:Color(red:0x67, green:0x85, blue:0xB4))
    public static var defaultBackgroundHoverFillStyle = FillStyle(color:Color(red:0x77, green:0x95, blue:0xD4))

    // Panel foreground and background styles
    public static var defaultPanelStrokeStyle = StrokeStyle(color:Color(.black))
    public static var defaultPanelFillStyle   = FillStyle(color:Color(.darkslategray))
    
    // Rounding percentage (0.0 is square, 0.5 is maximum)
    public static var defaultRoundingPercentage    = 0.20

    // Padding (between lines and text)
    public static var defaultPadding               = 5

    // Cursor styles
    public static var defaultNormalCursorStyle = CursorStyle.Style.defaultCursor
    public static var defaultHoverCursorStyle  = CursorStyle.Style.pointer

    // Labels display enclosing rectangle
    public static var defaultLabelsDisplayEnclosingRect   = false

    // Text
    public var font                  : String
    public var textFillMode          : FillMode
    public var textStrokeStyle       : StrokeStyle
    public var textFillStyle         : FillStyle
    
    // Foreground and background styles
    public var foregroundStrokeStyle    : StrokeStyle
    public var backgroundFillStyle      : FillStyle
    public var backgroundHoverFillStyle : FillStyle

    // Panel foreground and background styles
    public var panelStrokeStyle         : StrokeStyle
    public var panelFillStyle           : FillStyle

    // Rounding percentage (0.0 is square, 0.5 is maximum)
    public var roundingPercentage    : Double

    // Padding (between lines and text)
    public var padding               : Int

    // Cursor styles
    public var normalCursorStyle : CursorStyle.Style
    public var hoverCursorStyle  : CursorStyle.Style

    // Labels display enclosing rectangle
    public var labelsDisplayEnclosingRect : Bool
    
    public init(font:String? = nil,
                textFillMode:FillMode? = nil,
                textStrokeStyle:StrokeStyle? = nil,
                textFillStyle:FillStyle? = nil,
                
                foregroundStrokeStyle:StrokeStyle? = nil,
                backgroundFillStyle:FillStyle? = nil,
                backgroundHoverFillStyle:FillStyle? = nil,
                
                panelStrokeStyle:StrokeStyle? = nil,
                panelFillStyle:FillStyle? = nil,
                
                roundingPercentage:Double? = nil,
                
                padding:Int? = nil,
                
                normalCursorStyle:CursorStyle.Style? = nil,
                hoverCursorStyle:CursorStyle.Style? = nil,

                labelsDisplayEnclosingRect:Bool? = nil

    ) {
        self.font                     = font                     ?? Self.defaultFont
        self.textFillMode             = textFillMode             ?? Self.defaultTextFillMode
        self.textStrokeStyle          = textStrokeStyle          ?? Self.defaultTextStrokeStyle
        self.textFillStyle            = textFillStyle            ?? Self.defaultTextFillStyle
        
        self.foregroundStrokeStyle    = foregroundStrokeStyle    ?? Self.defaultForegroundStrokeStyle
        self.backgroundFillStyle      = backgroundFillStyle      ?? Self.defaultBackgroundFillStyle
        self.backgroundHoverFillStyle = backgroundHoverFillStyle ?? Self.defaultBackgroundHoverFillStyle

        self.panelStrokeStyle         = panelStrokeStyle         ?? Self.defaultPanelStrokeStyle
        self.panelFillStyle           = panelFillStyle           ?? Self.defaultPanelFillStyle
        
        self.roundingPercentage       = roundingPercentage       ?? Self.defaultRoundingPercentage
        
        self.padding                  = padding                  ?? Self.defaultPadding

        self.normalCursorStyle        = normalCursorStyle        ?? Self.defaultNormalCursorStyle
        self.hoverCursorStyle         = hoverCursorStyle         ?? Self.defaultHoverCursorStyle

        self.labelsDisplayEnclosingRect = labelsDisplayEnclosingRect ?? Self.defaultLabelsDisplayEnclosingRect
    }
}
