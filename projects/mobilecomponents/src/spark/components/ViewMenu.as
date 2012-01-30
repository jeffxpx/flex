////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//       
////////////////////////////////////////////////////////////////////////////////
package spark.components
{
import flash.display.StageOrientation;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.StageOrientationEvent;
import flash.ui.Keyboard;

import mx.core.InteractionMode;
import mx.core.mx_internal;
import mx.managers.IFocusManagerComponent;

import spark.core.NavigationUnit;

use namespace mx_internal;

[DefaultProperty("items")]

[SkinState("normalAndLandscape")]
[SkinState("disabledAndLandscape")]

/**
 *  The ViewMenu class display a set of ViewMenuItems. MobileApplication 
 *  will automatically create and display an ViewMenu when the user has 
 *  pressed the device's Menu button. 
 * 
 *  ViewMenu's default layout is ViewMenuLayout
 * 
 *  Set the items property to a Vector of ViewMenuItems.
 */ 

/*

TODO:

- add transitions
- use PopUpAnchor instead of PopUpManager
- integrate into TabbedMobileApplication

*/

public class ViewMenu extends SkinnableContainer implements IFocusManagerComponent
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor 
     */ 
    public function ViewMenu()
    {
        super();
        // Listen for orientation change events when we are attached to the stage
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  caretIndex
    //----------------------------------
    
    private var _caretIndex:int = -1;
    private var oldCaretIndex:int = -1;
    private var caretIndexChanged:Boolean = false;
    
    /**
     *  The item that is currently in the caret state. A value of -1 means that
     *  no item is in the caret state.  
     * 
     *  @default -1
     */   
    public function get caretIndex():int
    {
        return _caretIndex;
    }
    
    public function set caretIndex(value:int):void
    {
        if (_caretIndex == value)
            return;
     
        oldCaretIndex = _caretIndex;
        
        _caretIndex = value;
        caretIndexChanged = true;
        invalidateProperties();
    }
    
    //----------------------------------
    //  items
    //----------------------------------
    
    private var _items:Vector.<ViewMenuItem>;
    
    /**
     *  The Vector of ViewMenuItems to display in the ViewMenu
     */    
    public function get items():Vector.<ViewMenuItem>
    {
        return _items;
    }
    
    public function set items(value:Vector.<ViewMenuItem>):void
    {
        _items = value;
        
        var elements:Array = [];
        
        if (value)
        {
            for (var i:int = 0; i < value.length; i++)
            {
                elements.push(_items[i]);
            }
        }
        
        mxmlContent = elements;
        
    }

    // Returns true if the stage is in landscape orientation
    private function get landscapeOrientation():Boolean
    {
        if (systemManager && systemManager.stage)
            return systemManager.stage.deviceOrientation == StageOrientation.ROTATED_LEFT ||
                systemManager.stage.deviceOrientation == StageOrientation.ROTATED_RIGHT;
        else
            return false;
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    override protected function commitProperties():void
    {
        super.commitProperties();
            
        if (caretIndexChanged)
        {
            caretIndexChanged = false;
            
            // Hide the old caret and show the new one
            setShowsCaret(oldCaretIndex, false);
            setShowsCaret(caretIndex, true);
        }
    }
    
    /**
     *  @private
     *  Build in basic keyboard navigation support in ViewMenu. 
     */
    override protected function keyDownHandler(event:KeyboardEvent):void
    {   
        super.keyDownHandler(event);
                
        if (!items || !layout || event.isDefaultPrevented())
            return;
        
        // 1. Was the space bar hit? 
        // Hitting the space bar means the current caret item, 
        // that is the item currently in focus, is being 
        // selected. 
        if (event.keyCode == Keyboard.SPACE)
        {
            selectItemAt(caretIndex); 
            event.preventDefault();
            return; 
        }
        
        // FIXME (rfrishbe): hack for 5-way
        if (getStyle("interactionMode") == InteractionMode.TOUCH && event.keyCode == Keyboard.ENTER)
        {
            selectItemAt(caretIndex); 
            event.preventDefault();
            return; 
        }
        
        // 3. Was a navigation key hit (like an arrow key,
        // or Shift+arrow key)?  
        // Delegate to the layout to interpret the navigation
        // key and adjust the selection and caret item based
        // on the combination of keystrokes encountered.      
        adjustSelectionAndCaretUponNavigation(event); 
    }
    
    override protected function getCurrentSkinState():String
    {
        if (!landscapeOrientation)
            return super.getCurrentSkinState();
        else
            return enabled ? "normalAndLandscape" : "disabledAndLandscape";                
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function addedToStageHandler(event:Event):void
    {
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
        systemManager.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler, true);
    }
    
    private function removedFromStageHandler(event:Event):void
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
        systemManager.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler, true);
    }
    
    // Update the size and display if orientation has changed
    private function orientationChangeHandler(event:StageOrientationEvent):void
    {
        invalidateSkinState();
        invalidateSize();
        invalidateDisplayList();
    }
    
    /**
     *  Adjusts the selection based on what keystroke or 
     *  keystroke combinations were encountered. The keystroke
     *  is sent down to the layout and it is up to the layout's
     *  getNavigationDestinationIndex() method to determine 
     *  what the index to navigate to based on the item that 
     *  is currently in focus. Once the index is determined, 
     *  single selection, caret item and if necessary, multiple 
     *  selections are updated to reflect the newly selected
     *  item.  
     *
     *  @param event The Keyboard Event encountered
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function adjustSelectionAndCaretUponNavigation(event:KeyboardEvent):void
    {
        // If rtl layout, need to swap Keyboard.LEFT and Keyboard.RIGHT.
        var navigationUnit:uint = mapKeycodeForLayoutDirection(event);
        
        // Some unrecognized key stroke was entered, return. 
        if (!NavigationUnit.isNavigationUnit(event.keyCode))
            return; 
        
        // Delegate to the layout to tell us what the next item is we should select or focus into.
        // TODO (dsubrama): At some point we should refactor this so we don't depend on layout
        // for keyboard handling. If layout doesn't exist, then use some other keyboard handler
        var proposedNewIndex:int = layout.getNavigationDestinationIndex(caretIndex, navigationUnit, false); 
        
        // Note that the KeyboardEvent is canceled even if the current selected or in focus index
        // doesn't change because we don't want another component to start handling these
        // events when the index reaches a limit.
        if (proposedNewIndex == -1)
            return;
        
        event.preventDefault(); 
        
        // Entering the caret state with the Ctrl key down 
        // FIXME (rfrishbe): shouldn't just check interactionMode but should depend on 
        // either the platform or whether it was a 5-way button or whether 
        // soem other keyboardSelection style.
        if (event.ctrlKey || getStyle("interactionMode") == InteractionMode.TOUCH)
        {
            setShowsCaret(caretIndex, false);
            _caretIndex = proposedNewIndex;
            setShowsCaret(caretIndex, true);
        }
    }
    
   
    // Called when a particular item is selected using the ENTER or SPACE key 
    private function selectItemAt(index:int):void
    {
        if (index < 0 || !items || index >= items.length)
            return;
        
        var item:ViewMenuItem = ViewMenuItem(getElementAt(index));
        item.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
    }
    
    // Helper function which updates the item's caret state
    private function setShowsCaret(index:int, showsCaret:Boolean):void
    {
        if (index < 0 || !items || index >= items.length)
            return;
        
        var item:ViewMenuItem = ViewMenuItem(getElementAt(index));
        item.showsCaret = showsCaret;
    }
}
}