//
//  Card.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import Foundation
import SwiftUI

struct Card {
    var question: String
    var answer: String
    var description: String

    static let example = Card(question: "全国に城の数はいくつあった？", answer: "2万5,000～3万ほどと言われます。", description: "日本には城が2万5,000～3万ほどあったと言われています。数字の開きがあるのは、どこからどこまでが城なのか定義があいまいだから。一般的に「城」と聞くと、天守を思い浮かべますが、実は天守があるのは約100城で、現存している天守や再建された天守などがこれに含まれます。また、現在天守がない場合、もともと天守が作られていなかった場合はもちろん、石碑のみを残す場合や環濠集落（かんごうしゅうらく：まわりに堀を巡らせた集落）、幕末に作られた砲台跡（台場）も城に含まれることがあり、一概に城の数を示すことはできません。天守のない城も魅力は盛りだくさん。石垣や堀をはじめとした遺構で、歴史を感じることができます。")
}
