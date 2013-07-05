package com.inoah.ro.displays
{
    import com.inoah.ro.structs.acth.AnyActAnyPat;
    /**
     * body view 
     * @author inoah
     * 
     */    
    public class ActSprBodyView extends ActSprView
    {
        /**
         * 0 weapon, 1 headEquip 
         */
        private var _otherViews:Vector.<ActSprOtherView>;
        private var _headView:ActSprHeadView;
        private var _weaponView:ActSprWeaponView;
        
        public function get headView():ActSprHeadView
        {
            return _headView;
        }
        public function get weaponView():ActSprWeaponView
        {
            return _weaponView;
        }
        
        public function get otherViews():Vector.<ActSprOtherView>
        {
            return _otherViews;
        }
        
        public function ActSprBodyView()
        {
            super();
            _headView = new ActSprHeadView( this ); 
            _weaponView = new ActSprWeaponView( this );
//            _otherViews = new Vector.<ActSprOtherView>();
//            _otherViews[0] = new ActSprOtherView( this );
//            _otherViews[1] = new ActSprOtherView( this );
        }
        
        override public function set actionIndex( value:uint ):void 
        {
            if( _actionIndex != value )
            {
                _actionIndex = value;
                _currentFrame = 0;
                if( _headView )
                {
                    _headView.actionIndex = value;
                }
                if( _weaponView )
                {
                    _weaponView.actionIndex = value;
                }
            }
        }
        override public function set currentFrame( value:uint ):void
        {
            _currentFrame = value;
            if( _headView )
            {
                _headView.currentFrame = value;
            }
            if( _weaponView )
            {
                _weaponView.currentFrame = value;
            }
        }
        
        public function get currentAaap():AnyActAnyPat
        {
            return _currentAaap;
        }
        
        override public function tick(delta:Number):void
        {
            super.tick( delta );
            //only stand
            if( _actionIndex < 8 || (_actionIndex >=16) && (_actionIndex < 24)  )
            {
                currentFrame = 2;
            }
            if( _headView )
            {
                _headView.tick( delta );
            }
            //weaponView
            if( _weaponView )
            {
                _weaponView.tick( delta );
            }
//            if( otherViews[0] )
//            {
//                otherViews[0].tick( delta );
//            }
        }
    }
}