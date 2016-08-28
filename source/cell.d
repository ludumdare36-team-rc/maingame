module game.cell;

/**
 */
enum CellType {
    Broken,
    Empty,
    House,
    Ferm,
    Factory,
}

///
struct Cell{
    enum int size = 32;
    import game.entity;
    
    ///
    CellType type()const{
        return _cellType;
    }
    
    void type(in CellType type){
        import std.random;
        _textureIndex = uniform(0, 10);
        _cellType = type;
    }
    
    ///
    void brake(){
        _cellType = CellType.Broken;
    }
    
    ///
    void update(){}
    
    ///
    void draw(){
        import std.stdio;
        "draw cell".writeln;
        switch (_cellType) {
            case CellType.Empty:
                drawEmpty;
                break;
            case CellType.House:
                drawHouse;
                break;
            default:
                assert(0);
        }
    }
    
    ///
    void dropEntity(in int height){
        import std.algorithm;
        import armos.math;
        foreach (entity; _entities) {
            entity.pos = entity.pos - Vector3i(0, height, 0);
        }
    }
    
    ///
    void isEdge(in int v){
        _isEdge = v;
    }
    
    private{
        CellType _cellType = CellType.Empty;
        Entity[] _entities;
        int _textureIndex;
        int _isEdge = 0;
        int _life = 0;
        
        void drawEmpty(){
            import game.resources;
            animations("cell_empty", 1).index(0).draw;
        }
        
        void drawHouse(){
            import game.resources;
            if(_isEdge == 0){
                animations("cell_house", 7).index(2+_textureIndex%5).draw;
            }else if(_isEdge == -1){
                animations("cell_house", 7).index(0).draw;
            }else{
                animations("cell_house", 7).index(1).draw;
            }
        }
        
    }
}
