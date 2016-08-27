module game.animation;
import armos.graphics;
<<<<<<< HEAD
import armos.math;
=======
>>>>>>> cf374d6287d1a8bd3d3f985c1c706acda44f0015

/++
+/
class Animation {
    public{
        this(){
            _mesh = new Mesh;
            _mesh.primitiveMode = PrimitiveMode.TriangleStrip;
        }
        
        ///
        this(in string imageNamePrefix, in size_t maxImages = 0){
            this();
            _imageNamePrefix = imageNamePrefix;
            _maxImages = maxImages;
            load;
        }
        
        ///
        Animation load(in string imageNamePrefix, in size_t maxImages= 0){
            _imageNamePrefix = imageNamePrefix;
            _maxImages = maxImages;
            loadTextures;
            
            _mesh.addTexCoord(0, 1);_mesh.addVertex(0, 0, 0);
            _mesh.addTexCoord(0, 0);_mesh.addVertex(0, height, 0);
            _mesh.addTexCoord(1, 1);_mesh.addVertex(width, 0, 0);
            _mesh.addTexCoord(1, 0);_mesh.addVertex(width, height, 0);
            
            _mesh.addIndex(0);
            _mesh.addIndex(1);
            _mesh.addIndex(2);
            _mesh.addIndex(3);
            
            return this;
        }
        
        ///
        Animation load(){
            load(_imageNamePrefix, _maxImages);
            return this;
        }
        
        ///
        Animation draw(V)(in V v){
            pushMatrix;
            translate(v);
            draw;
            popMatrix;
            return this;
        }
        
        ///
        Animation draw(){
            begin;
            _mesh.drawFill;
            end;
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
        
        string    _imageNamePrefix;
        size_t    _maxImages;
        size_t    _currentIndex = 0;
        Texture[] _textures;
        Mesh      _mesh;
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
