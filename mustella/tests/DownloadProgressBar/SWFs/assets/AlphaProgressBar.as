////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package
{
import flash.utils.*;
import mx.controls.Image;
import mx.preloaders.*;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
public class AlphaProgressBar extends mx.preloaders.DownloadProgressBar
{
    public function AlphaProgressBar()
    {
        super();
    }
    
    override public function initialize():void
    {
        super.initialize();
        backgroundColor= 0xFF0000;
        backgroundAlpha=0.3;
        MINIMUM_DISPLAY_TIME = 2000;
    }
    
    override protected function showDisplayForInit(elapsedTime:int, count:int):Boolean
    {
        return true;
    }
    
    override protected function showDisplayForDownloading(elapsedTime:int,
                                              event:ProgressEvent):Boolean
    {
        return true;
    }
}          
}