package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.uis.TopText;
    
    import flash.events.Event;
    
    public class AssetMgr implements IMgr
    {
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
        
        public function getResList( resPathList:Vector.<String>, callBack:Function, onProgress:Function = null ):void
        {
            var len:int = resPathList.length;
            for( var i:int =0;i<len;i++)
            {
                _loaderList.push( new ActSprLoader( resPathList[i] ) );
                if( i == len - 1 )
                {
                    _callBackList.push( callBack );
                }
                else
                {
                    _callBackList.push( null );
                }
            }
            
            if( _isLoading == false )
            {
                loadNext();
            }
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
                    if( _callBackList[0] != null )
                    {
                        _callBackList[0].apply( null, [ _cacheList[ _cacheListIndex.indexOf(_loaderList[0].actUrl) ] ] );
                    }
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
            TopText.show( "加载完成..." + loader.actUrl );
            _cacheList.push( loader );
            _cacheListIndex.push( loader.actUrl );
            
            if( _callBackList[0] != null )
            {
                _callBackList[0].apply( null, [loader]);
            }
            _loaderList.shift();
            _callBackList.shift();
            _isLoading = false;
            loadNext();
        }
    }
}