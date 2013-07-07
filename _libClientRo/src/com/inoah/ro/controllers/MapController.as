package com.inoah.ro.controllers
{
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class MapController
    {
        private var _root:Sprite;
        
        private var _bgBmp:Bitmap;
        private var _currentContaner:Sprite;
        
        public function MapController( root:Sprite )
        {
            _root = root;
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            var cls:Class = assetMgr.getClass( "BG_CLASS" );
            _bgBmp = new cls();
            _bgBmp.x = - 50;
            _bgBmp.y = - 50;
            _root.addChild( _bgBmp );
            
            _currentContaner = new Sprite();
            _root.addChild( _currentContaner );
        }
        
        public function tick( delta:Number ):void
        {
            var obj:DisplayObject;
            var len:int = _currentContaner.numChildren;
            var sortList:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            for( var i:int = 0;i<len;i++)
            {
                obj = _currentContaner.getChildAt( i );
                sortList.push( obj );
            }
            sortList.sort( sortObjFunc );
        }
        
        private function sortObjFunc( a:DisplayObject, b:DisplayObject ):Number
        {
            if(a.y > b.y)
            {
                if(_currentContaner.getChildIndex(a) < _currentContaner.getChildIndex(b))
                {
                    _currentContaner.swapChildren(a,b);
                }
                return 1;
            }else if(a.y < b.y)
            {
                if(_currentContaner.getChildIndex(a) > _currentContaner.getChildIndex(b))
                {
                    _currentContaner.swapChildren(a,b);
                }
                return -1;
            }else
            {
                return 0;
            }
        }
        
        public function get currentContainer():Sprite
        {
            return _currentContaner;
        }
    }
}