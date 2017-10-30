//
//  DvLog.hpp
//  MyGLES
//
//  Created by davi on 2017/10/29.
//  Copyright © 2017年 davi. All rights reserved.
//

#ifndef DvLog_hpp
#define DvLog_hpp

#include <stdio.h>
#include <iostream>
#define LOG_TAG "DV"

#ifdef DV_ANDROID

#include <android/log.h>
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

#elif DV_IOS
#define LOGD(...) std::cout<<LOG_TAG<<": "<<__VA_ARGS__<<std::endl;
#endif


#endif /* DvLog_hpp */
