//
//  Pizza_Ping_WidgetBundle.swift
//  Pizza Ping Widget
//
//  Created by Jonathan Berger on 11/24/25.
//

import WidgetKit
import SwiftUI

@main
struct Pizza_Ping_WidgetBundle: WidgetBundle {
    var body: some Widget {
        Pizza_Ping_Widget()
        Pizza_Ping_WidgetControl()
        Pizza_Ping_WidgetLiveActivity()
    }
}
