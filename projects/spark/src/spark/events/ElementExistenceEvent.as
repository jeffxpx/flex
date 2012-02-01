////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2006 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flex.events
{

import flash.events.Event;

/**
 *  Represents events that are dispatched when an item of a Group
 *  is created or destroyed. 
 */
public class ItemExistenceChangedEvent extends Event
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>ItemExistenceChangedEvent.ITEM_ADD</code> constant 
	 *  defines the value of the <code>type</code> property of the event 
	 *  object for an <code>itemAdd</code> event.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	 *     <tr><td><code>relatedObject</code></td><td>Contains a reference
     *         to the item that was created.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType itemAdd
	 */
	public static const ITEM_ADD:String = "itemAdd";

	/**
	 *  The <code>ItemExistenceChangedEvent.ITEM_REMOVE</code> constant 
	 *  defines the value of the <code>type</code> property of the event 
	 *  object for an <code>itemRemove</code> event.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	 *     <tr><td><code>relatedObject</code></td><td>Contains a reference
     *        to the item that is about to be removed.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType itemRemove
	 */
	public static const ITEM_REMOVE:String = "itemRemove";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param type The event type; indicates the action that caused the event.
	 *
	 *  @param bubbles Specifies whether the event can bubble up the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
	 *
	 *  @param relatedObject Reference to the item that was created or destroyed.
	 */
	public function ItemExistenceChangedEvent(
								type:String, bubbles:Boolean = false,
								cancelable:Boolean = false,
								relatedObject:* = undefined)
	{
		super(type, bubbles, cancelable);

		this.relatedObject = relatedObject;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  relatedObject
	//----------------------------------

	/**
	 *  Reference to the item that was created or destroyed.
	 */
	public var relatedObject:*;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
    override public function clone():Event
    {
        return new ItemExistenceChangedEvent(type, bubbles, cancelable,
                                             relatedObject);
    }
}

}
