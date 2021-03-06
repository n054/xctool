//
// Copyright 2013 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "SenIsSuperclassOfClassPerformanceFix.h"

#import "Swizzle.h"
#import "dyld-interposing.h"


static BOOL NSObject_senIsASuperclassOfClass(id self, SEL cmd, Class cls)
{
  if (cls == self) {
    return NO;
  }
  while (cls != nil && cls != self) {
    cls = class_getSuperclass(cls);
  }
  return cls != nil;
}

void XTApplySenIsSuperclassOfClassPerformanceFix()
{
  if ([NSObject respondsToSelector:@selector(senIsASuperclassOfClass:)]) {
    XTSwizzleClassSelectorForFunction([NSObject class],
                                      @selector(senIsASuperclassOfClass:),
                                      (IMP)NSObject_senIsASuperclassOfClass);
  }
}
