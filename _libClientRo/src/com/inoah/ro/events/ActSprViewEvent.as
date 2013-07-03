package com.inoah.ro.events
{
    import flash.events.Event;
    
    public class ActSprViewEvent extends Event
    {
        public static var ACTION_END:String = "ActSprViewEvent.action_end";
        
        public function ActSprViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}