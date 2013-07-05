package com.inoah.ro.characters
{
    import com.inoah.ro.displays.ActSprBodyView;
    import com.inoah.ro.displays.valueBar.ValueBarView;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.structs.CACT;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    /**
     * 
     * @author inoah
     * 
     */    
    public class CharacterView extends Sprite
    {
        protected var _charInfo:CharacterInfo;
        protected var _headLoader:ActSprLoader;
        protected var _bodyLoader:ActSprLoader;
        protected var _bodyView:ActSprBodyView;
        protected var _speed:Number;
        /**
         * 0 stand, 8 walk,  
         */        
        protected var _currentIndex:uint;
        /**
         * 0,下,1左下.....7 
         */        
        protected var _dirIndex:uint;
        protected var _targetPoint:Point;
        protected var _isMoving:Boolean;
        
        protected var _x:Number;
        protected var _y:Number;
        protected var _moveTime:Number;
        protected var _isAttacking:Boolean;
        
        protected var _headTopContainer:Sprite;
        protected var _label:TextField;
        protected var _hpValBar:ValueBarView;
        protected var _spValBar:ValueBarView;
        private var _weaponLoader:ActSprLoader;
        
        public function CharacterView( charInfo:CharacterInfo = null )
        {
            _isMoving = false;
            _targetPoint = new Point( 0, 0 );
            _speed = 100;
            if( charInfo )
            {
                _charInfo = charInfo;
                init();
            }
        }
        
        public function setCharInfo( charInfo:CharacterInfo ):void
        {
            _charInfo = charInfo;
            init();
        }
        
        override public function set x( x:Number ):void
        {
            _x = x;
            super.x = _x;
        }
        override public function set y( y:Number ):void
        {
            _y = y;
            super.y = _y;
        }
        
        protected function init():void
        {
            if(_headTopContainer == null)
            {
                _headTopContainer = new Sprite();
                _headTopContainer.y = -100;
                addChild( _headTopContainer );
            }
            _label = new TextField();
            _label.mouseEnabled = false;
            _label.filters = [new DropShadowFilter(0,0,0,1,2,2,8)];
            _label.alpha = 0.7;
            _label.autoSize = TextFieldAutoSize.LEFT;
            var tf:TextFormat = new TextFormat();
            tf.font = "宋体";
            tf.size = 12;
            tf.color = 0xffffff;
            _label.defaultTextFormat = tf;
            _label.text = _charInfo.name;
            _label.x = -_label.width / 2;
            _headTopContainer.addChild( _label );
            
            _hpValBar = new ValueBarView( 0x33ff33 , 0x333333 );
            _hpValBar.x = -_hpValBar.width / 2;
            _hpValBar.y = 15;
            addChild( _hpValBar );
            _hpValBar.update( 100, 100 );
            
            _spValBar = new ValueBarView( 0x2868FF , 0x333333 );
            _spValBar.x = -_spValBar.width / 2;
            _spValBar.y = 20;
            addChild( _spValBar );
            _spValBar.update( 50, 100 );
            
            updateCharInfo( _charInfo );
        }
        
        public function updateCharInfo( charInfo:CharacterInfo ):void
        {
            if( !_bodyLoader || _bodyLoader.actUrl != _charInfo.bodyRes )
            {
                _bodyLoader = new ActSprLoader( _charInfo.bodyRes );
                _bodyLoader.addEventListener( Event.COMPLETE, onBodyLoadComplete );
            }
            if( _charInfo.headRes )
            {
                _headLoader = new ActSprLoader( _charInfo.headRes );
                _headLoader.addEventListener( Event.COMPLETE, onHeadLoadComplete );
            }
            if( _charInfo.weaponRes )
            {
                _weaponLoader = new ActSprLoader( _charInfo.weaponRes );
                _weaponLoader.addEventListener( Event.COMPLETE, onWeaponLoadComplete );
            }
        }
        
        protected function onBodyLoadComplete( e:Event):void
        {
            _bodyLoader.removeEventListener( Event.COMPLETE, onBodyLoadComplete );
            if( !_bodyView )
            {
                _bodyView = new ActSprBodyView();
            }
            _bodyView.initAct( _bodyLoader.actData );
            _bodyView.initSpr( _bodyLoader.sprData );
            //noah
            _bodyView.actionIndex = 8;
            addChild( _bodyView );
        }
        
        protected function onHeadLoadComplete( e:Event):void
        {
            _headLoader.removeEventListener( Event.COMPLETE, onHeadLoadComplete );
            _bodyView.headView.initAct( _headLoader.actData );
            _bodyView.headView.initSpr( _headLoader.sprData );
            addChild( _bodyView );
            addChild( _bodyView.headView );
        }
        
        protected function onWeaponLoadComplete( e:Event):void
        {
            _weaponLoader.removeEventListener( Event.COMPLETE, onWeaponLoadComplete );
            _bodyView.weaponView.initAct( _weaponLoader.actData );
            _bodyView.weaponView.initSpr( _weaponLoader.sprData );
            addChild( _bodyView );
            addChild( _bodyView.headView );
            addChild( _bodyView.weaponView );
        }
        
        public function tick( delta:Number ):void
        {
            if( _bodyView )
            {
                _bodyView.tick( delta );
            }
            
            if( _isAttacking )
            {
                actionAttack();
            }
            else
            {
                if( _isMoving )
                {
                    actionWalk();
                }
                else
                {
                    actionStand();
                }
            }
        }
        
        public function actionStand():void
        {
            _currentIndex = 0;
            if( _bodyView )
            {
                _bodyView.actionIndex = _currentIndex + _dirIndex;
            }
        }
        
        public function actionWalk():void
        {
            _currentIndex = 8;
            if( _bodyView )
            {
                _bodyView.actionIndex = _currentIndex + _dirIndex;
            }
        }
        
        public function actionAttack():void
        {
            _currentIndex = 80;
//            _currentIndex = 40;
            if( _bodyView )
            {
                _bodyView.actionIndex = _currentIndex + _dirIndex;
            }
        }
        
        public function get bodyView():ActSprBodyView
        {
            return _bodyView;
        }
        
        public function get actionIndex():uint
        {
            return _currentIndex;
        }
        
        public function setActionIndex( value:uint ):void
        {
            _currentIndex = value;
            _bodyView.actionIndex = _currentIndex + _dirIndex;
        }
        
        public function setDirIndex( value:uint ):void
        {
            _dirIndex = value;
            _bodyView.actionIndex = _currentIndex + _dirIndex;
        }
        
        public function get actions():CACT
        {
            return _bodyView.actions;
        }
        
        public function set isMoving( value:Boolean ):void
        {
            _isMoving = value;
        }
        
        public function get isMoving():Boolean
        {
            return _isMoving;
        }
        
        public function set isAttacking( value:Boolean ):void
        {
            _isAttacking = value;
        }
        
        public function get isAttacking():Boolean
        {
            return _isAttacking;
        }
        
        public function set dirIndex( value:uint ):void
        {
            _dirIndex = value;
        }
        
        public function get dirIndex():uint
        {
            return _dirIndex;
        }
        
        public function get speed():uint
        {
            return _speed;
        }
    }
}