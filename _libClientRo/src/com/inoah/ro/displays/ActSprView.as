package com.inoah.ro.displays
{
    import com.inoah.ro.events.ActSprViewEvent;
    import com.inoah.ro.structs.CACT;
    import com.inoah.ro.structs.CSPR;
    import com.inoah.ro.structs.acth.AnyActAnyPat;
    import com.inoah.ro.structs.acth.AnyPatSprV0101;
    import com.inoah.ro.structs.acth.AnyPatSprV0201;
    import com.inoah.ro.structs.acth.AnyPatSprV0204;
    import com.inoah.ro.structs.acth.AnyPatSprV0205;
    import com.inoah.ro.structs.sprh.AnySprite;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.utils.ByteArray;
    
    /**
     * base actSpr view 
     * @author inoah
     * 
     */
    public class ActSprView extends Sprite
    {
        protected var _act:CACT;
        protected var _spr:CSPR;
        protected var _actionIndex:uint;
        protected var _currentFrame:uint;
        protected var _bitmap:Bitmap;
        protected var _counterTarget:Number;
        protected var _counter:Counter;
        protected var _couldTick:Boolean;
        protected var _currentAaap:AnyActAnyPat;
        
        public function get actions():CACT
        {
            return _act;
        }
        
        public function ActSprView()
        {
            _counter = new Counter();
            _counterTarget = 0.075;
            _counter.initialize();
            _counter.reset( _counterTarget );
        }
        
        public function get counterTarget():Number
        {
            return _counterTarget;
        }
        
        public function set counterTarget( value:Number ):void
        {
            _counterTarget = value;
        }
            
        public function set actionIndex( value:uint ):void 
        {
            if( _actionIndex != value )
            {
                _actionIndex = value;
                _currentFrame = 0;
            }
        }
        public function get actionIndex():uint
        {
            return   _actionIndex;
        }
        
        public function set currentFrame( value:uint ):void
        {
            _currentFrame = value;
        }
        
        public function initAct( data:ByteArray ):void
        {
            _couldTick = false;
            if( _act )
            {
                _act.destory();
            }
            _act= new CACT( data );
            _counter.reset( _counterTarget );
            _actionIndex = 0;
            _currentFrame = 0;
        }
        
        public function initSpr( data:ByteArray ):void
        {
            if( _spr )
            {
                _spr.destory();
            }
            _spr = new CSPR( data , data.length );
            _counter.reset( _counterTarget );
            _couldTick = true;
        }
        
        //下，左下，左，左上，上，右上，右，右下
        //0 , 1 , 2 , 3 , 4 , 5 , 6 , 7
        //静态 0-7
        //行走 8-15
        //左下 16-23
        //拾取 24-31
        //待机 32-39 
        //攻击 40-47
        //防御 48-55
        //倒下 56-63
        //躺下 64-71
        //未知 72 -29
        //踩脚 80-87
        //未知 88-95
        //魔法 96-103
        
        public function tick(delta:Number):void
        {
            if( !_couldTick )
            {
                return;
            }
            _counter.tick( delta );
            if( _counter.expired )
            {
                _counter.reset( _counterTarget );
                _currentFrame++;
                if( _currentFrame >= _act.aall.aa[_actionIndex].aaap.length )
                {
                    _currentFrame = 0;
                    dispatchEvent(new ActSprViewEvent( ActSprViewEvent.ACTION_END, true ));
                }
            }
            else 
            {
                return;
            }
            
            _currentAaap = _act.aall.aa[_actionIndex].aaap[_currentFrame];
            
            var isExt:Boolean = false;
            var apsv:AnyPatSprV0101 = _currentAaap.apsList[0];
            if( apsv.sprNo == 0xffffffff )
            {
                apsv = _currentAaap.apsList[1];
                isExt = true;
            }
            if( apsv as AnyPatSprV0101 )
            {
                var anySprite:AnySprite;
                anySprite = _spr.imgs[ apsv.sprNo ];
                
                if( !_bitmap )
                {
                    _bitmap = new Bitmap( anySprite.drawbitmap() );
                    addChild( _bitmap );
                }
                else
                {
                    _bitmap.bitmapData = anySprite.drawbitmap();
                }
                if( apsv.mirrorOn == 0 )
                {
                    _bitmap.x = -_bitmap.width / 2 + apsv.xOffs;
                    _bitmap.y = -_bitmap.height / 2 + apsv.yOffs;
                    _bitmap.scaleX = 1;
                }
                else
                {
                    _bitmap.x = _bitmap.width / 2 + apsv.xOffs;
                    _bitmap.y = -_bitmap.height / 2 + apsv.yOffs;
                    _bitmap.scaleX = -1;
                }
            }
            if( apsv as AnyPatSprV0201 )
            {
                apsv.color;
                apsv.xyMag;
                //                _bitmap.rotation = 
                apsv.rot;
                apsv.spType;
            }
            if( apsv as AnyPatSprV0204 )
            {
                apsv.xMag;
                apsv.yMag;
            }
            if( apsv as AnyPatSprV0205 )
            {
                apsv.sprW;
                apsv.sprH;
            }
        }
    }
}