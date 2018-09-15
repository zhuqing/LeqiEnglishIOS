//
//  NSDate_extension.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/14.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

extension NSDate{
    class func getTime()->Int64{
      return Int64(self.timeIntervalSinceReferenceDate*1000)
    }
}
