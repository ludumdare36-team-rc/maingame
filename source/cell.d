module game.cell;

import armos.math;
import game.entity;
import game.soldier;

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
        return _type;
    }
    
    void soldierType(in SoldierType t){
        _soldierType = t;
        _age = 1;
    }
    
    void type(in CellType type){
        import std.random;
        _textureIndex = uniform(0, 10);
        _type = type;
    }
    
    ///
    void update(in Vector2i pos, ref Entity[] entities){
        if(_age%(60*30) == 0){
            import std.stdio;
            switch (_type) {
                case CellType.House:
                //TODO spawn 
                    "spawn".writeln;
                    import game.resident;
                    Resident resident = new Resident();
                    resident.pos = Vector3i(pos[0], pos[1], 0);
                    entities ~= resident;
                    import std.stdio;
                    entities.length.writeln;
                    break;
                case CellType.Factory:
                //TODO spawn 
                    break;
                case CellType.Ferm:
                //TODO increment remaining of foods
                    break;
                default:
            }
        }
        
        _age++;
    }
    
    ///
    void draw(){
        switch (_type) {
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
        CellType _type = CellType.Empty;
        SoldierType _soldierType = SoldierType.Infantry;
        Entity[] _entities;
        int _textureIndex;
        int _isEdge = 0;
        int _life = 0;
        ulong _age = 0;;
        
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
