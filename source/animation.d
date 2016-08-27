module game.animation;
import armos.graphics;

/++
+/
class Animation {
    public{
        this(){}
        
        ///
        this(in string imageNamePrefix, in size_t maxImages = 0){
            _imageNamePrefix = imageNamePrefix;
            _maxImages = maxImages;
            load;
        }
        
        ///
        Animation load(in string imageNamePrefix, in size_t maxImages= 0){
            _imageNamePrefix = imageNamePrefix;
            _maxImages = maxImages;
            loadTextures;
            return this;
        }
        
        ///
        Animation load(){
            load(_imageNamePrefix, _maxImages);
            return this;
        }
        
        ///
        size_t width()const{return _textures[0].width;}
        
        ///
        size_t height()const{return _textures[0].height;}
        
        ///
        Animation currentIndex(in size_t index)
        in{
            assert(index < _maxImages);
        }body{
            _currentIndex = index;
            return this;
        }
        
        ///
        size_t currentIndex()const{
            return _currentIndex;
        }
        
        ///
        Animation begin(){
            _textures[_currentIndex].begin;
            return this;
        }
        
        ///
        Animation end(){
            _textures[_currentIndex].end;
            return this;
        }
    }//public

    private{
        Animation loadTextures(){
            Image _imageLoader = new Image;
            
            import std.array;
            //TODO
            // _textures = Texture[]();
            import std.range;
            if(_maxImages == 1){
                string fileName = _imageNamePrefix ~ ".png";
                import std.stdio;
                fileName.writeln;
                _imageLoader.load(fileName);
                _textures ~= _imageLoader.texture;
            }else{
                foreach (size_t i; _maxImages.iota.array) {
                    string fileName = animationFileName(_imageNamePrefix, i);
                    import std.stdio;
                    fileName.writeln;
                    _imageLoader.load(fileName);
                    Texture tmp = _imageLoader.texture;
                    tmp.setMinMagFilter(TextureFilter.Nearest);
                    _textures ~= tmp;
                }
            }
            return this;
        }
        
        string _imageNamePrefix;
        size_t _maxImages;
        size_t _currentIndex = 0;
        Texture[] _textures;
    }//private
}//class Animation

private string animationFileName(in string imageNamePrefix, in size_t index){
    string name;
    import std.conv;
    name = imageNamePrefix ~ (index+1).to!string ~ ".png";
    return name;
}

unittest{
    assert(animationFileName("number", 0) == "number1.png");
    assert(animationFileName("number", 9) == "number10.png");
}
