package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    import com.inoah.ro.loaders.ActSprLoader;
    
    import flash.events.Event;
    
    public class AssetMgr implements IMgr
    {
        [Embed(source="../../../../bg.jpg" , mimeType="image/jpeg")]
        public var BG_CLASS:Class;
        
        private var _cacheList:Vector.<ActSprLoader>;
        private var _cacheListIndex:Vector.<String>;
        private var _loaderList:Vector.<ActSprLoader>;
        private var _callBackList:Vector.<Function>;
        private var _isLoading:Boolean;
        
        public function AssetMgr()
        {
            _cacheList = new Vector.<ActSprLoader>();
            _cacheListIndex = new Vector.<String>();
            _loaderList = new Vector.<ActSprLoader>();
            _callBackList = new Vector.<Function>(); 
        }
        
        public function dispose():void
        {
            
        }
        
        public function get isDisposed():Boolean
        {
            return false;
        }
        
        public function getClass( strClassName:String ):Class
        {
            return this[ strClassName ];
        }
        
        public function getRes( resPath:String, callBack:Function ):void
        {
            _loaderList.push( new ActSprLoader( resPath ) );
            _callBackList.push( callBack );
            
            if( _isLoading == false )
            {
                loadNext();
            }
        }
        
        private function loadNext():void
        {
            if( _loaderList.length > 0 )
            {
                if( _cacheListIndex.indexOf( _loaderList[0].actUrl ) == -1  )
                {
                    _isLoading = true;
                    _loaderList[0].addEventListener( Event.COMPLETE , onLoadComplete );
                    _loaderList[0].load();
                }
                else
                {
                    _callBackList[0].apply( null, [ _cacheList[ _cacheListIndex.indexOf(_loaderList[0].actUrl) ] ] );
                    _loaderList.shift();
                    _callBackList.shift();
                    loadNext();
                }
            }
        }
        
        private function onLoadComplete( e:Event ):void
        {
            var loader:ActSprLoader = e.currentTarget as ActSprLoader;
            loader.removeEventListener( Event.COMPLETE, onLoadComplete );
            trace( "[AssetMgr] loadComplete " + loader.actUrl );
            _cacheList.push( loader );
            _cacheListIndex.push( loader.actUrl );
            
            _callBackList[0].apply( null, [loader]);
            _loaderList.shift();
            _callBackList.shift();
            _isLoading = false;
            loadNext();
        }
    }
}