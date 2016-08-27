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
    int getType(){
        return _cellType;
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
        if(_cellType == CellType.House)drawHouse;
    }
    
    void dropEntity(in int height){
        import std.algorithm;
        import armos.math;
        foreach (entity; _entities) {
            entity.pos = entity.pos - Vector3i(0, height, 0);
        }
    }
    
    void isEdge(int v){
        _isEdge = v;
    }
    
    private{
        CellType _cellType = CellType.House;
        Entity[] _entities;
        int _textureIndex;
        int _isEdge = 0;
        
        void drawHouse(){
            import game.resources;
            if(_isEdge == 0){
                animations("roomA", 7).index(2).draw;
            }else if(_isEdge == -1){
                animations("roomA", 7).index(0).draw;
            }else{
                animations("roomA", 7).index(1).draw;
            }
        }
        
    }
}
