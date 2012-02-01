<?xml version="1.0" encoding="utf-8"?>

<!--

    ADOBE SYSTEMS INCORPORATED
    Copyright 2008 Adobe Systems Incorporated
    All Rights Reserved.

    NOTICE: Adobe permits you to use, modify, and distribute this file
    in accordance with the terms of the license agreement accompanying it.

-->

<!--- The default skin class for a Spark DefaultItemRenderer class.  
        
      @langversion 3.0
      @playerversion Flash 10
      @playerversion AIR 1.5
      @productversion Flex 4
-->
<s:ItemRenderer focusEnabled="false" xmlns:fx="http://ns.adobe.com/mxml/2009" xmlns:s="library://ns.adobe.com/flex/spark">
    
    <fx:Script>
        <![CDATA[
            
            override public function set labelText(value:String):void
            {
                super.labelText = value;
                labelElement.text = labelText; 
            }
        ]]>
    </fx:Script>
    
    
    <s:states>
        <s:State name="normal" />            
        <s:State name="hovered" />
        <s:State name="selected" />
        <s:State name="normalAndCaret"/>
        <s:State name="hoveredAndCaret"/>
        <s:State name="selectedAndCaret"/>
    </s:states>
    
    <s:Rect left="0" right="0" top="0" bottom="0">
        <s:stroke.normalAndCaret>
            <s:SolidColorStroke 
                color="{selectionColor}" 
                weight="1"/>
        </s:stroke.normalAndCaret>
        <s:stroke.hoveredAndCaret>
            <s:SolidColorStroke 
                color="{selectionColor}" 
                weight="1"/>
        </s:stroke.hoveredAndCaret>
        <s:stroke.selectedAndCaret>
            <s:SolidColorStroke 
                color="{selectionColor}" 
                weight="1"/>
        </s:stroke.selectedAndCaret>
        <s:fill>
            <s:SolidColor 
            	color.normal="{contentBackgroundColor}"
                color.normalAndCaret="{contentBackgroundColor}"
                color.hovered="{rollOverColor}"	
                color.hoveredAndCaret="{rollOverColor}"
            	color.selected="{selectionColor}"
                color.selectedAndCaret="{selectionColor}"
            	/>
        </s:fill>
    </s:Rect>
    <s:SimpleText id="labelElement" verticalCenter="0" left="3" right="3" top="6" bottom="4"/>

</s:ItemRenderer>
