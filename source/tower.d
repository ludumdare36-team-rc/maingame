module game.tower;

import game.floor;
import game.cell;
import armos.math;
import game.entity;
import game.soldier;

/**
 */
class Tower{
    this(in Vector2i size){
        _size = size;
        import std.range;
        foreach (ref j; size[1].iota.array) {
            Cell[] floor = new Cell[size[0]];
            foreach (int index, ref cell; floor) {
                if(index == 0) cell.isEdge = -1;
                if(index == floor.length-1) cell.isEdge = 1;
            }
            _cells ~= floor;
        }
    }
    
    ///
    void update(ref Entity[] entities){
        foreach (int f, floor; _cells) {
            foreach (int n, ref cell; floor) {
                cell.update(Vector2i(n, f)*Cell.size, entities);
            }
        }
        
        foreach (int f, floor; _cells) {
            bool isBrokenFloor = true;
            foreach (ref cell; floor) {
                isBrokenFloor = isBrokenFloor && cell.type == CellType.Broken;
            }
            if(isBrokenFloor) dropFloor(f);
        }
    };
    
    void draw(){
        import armos.graphics;
        pushMatrix;
        foreach (floor; _cells) {
            pushMatrix;
            foreach (ref cell; floor) {
                cell.draw();
                translate(Cell.size, 0, 0);
            }
            popMatrix;
            translate(0, Cell.size, 0);
        }
        popMatrix;
        
        import game.resources;
        pushMatrix;
        translate(cursorPosition[0]*Cell.size, cursorPosition[1]*Cell.size, 0);
        animations("cursor", 1).index(0).draw;
        popMatrix;
    }
    
    void dropFloor(in size_t n){
        foreach (floor; _cells[n+1.._cells.length]) {
            foreach (ref cell; floor) {
                cell.dropEntity(Cell.size);
            }
        }
        
        deleteFloor(n);
    }

    
    ref Cell cell(in Vector2i position){
        return _cells[position[1]][position[0]];
    }
    
    ///
    Vector2i cursorPosition()const{
        return _cursorPosition;
    }
    
    ///
    void cursorMoveLeft(){
        cursorPosition = cursorPosition + Vector2i(-1, 0);
    }
    
    ///
    void cursorMoveRight(){
        cursorPosition = cursorPosition + Vector2i(1, 0);
    }
    
    ///
    void cursorMoveUp(){
        cursorPosition = cursorPosition + Vector2i(0, 1);
    }
    
    ///
    void cursorMoveDown(){
        cursorPosition = cursorPosition + Vector2i(0, -1);
    }
    
    ///
    void buildCellToCurrentCursor(in CellType type, in SoldierType soldierType = SoldierType.Infantry){
        if(cell(_cursorPosition).type != type){
            cell(_cursorPosition).type = type;
            cell(_cursorPosition).soldierType = soldierType;
            if(isFillFloor(_size[1]-1)){
                addFloor;
            }
        }
    }
    
    void addFloor(){
        Cell[] floor = new Cell[_size[0]];
        foreach (int index, ref cell; floor) {
            if(index == 0) cell.isEdge = -1;
            if(index == floor.length-1) cell.isEdge = 1;
        }
        _cells ~= floor;
        import std.conv;
        _size[1] = _cells.length.to!int;
    }
    
    ///
    bool isFillFloor(in size_t f)const{
        bool isNotEmptyFloor = true;
        foreach (ref cell; _cells[f]) {
            isNotEmptyFloor = isNotEmptyFloor && cell.type != CellType.Empty;
        }
        return isNotEmptyFloor;
    }
    
    ///
    bool isBrokenFloor(in size_t f)const{
        bool isBrokenFloor = true;
        foreach (ref cell; _cells[f]) {
            isBrokenFloor = isBrokenFloor && cell.type == CellType.Broken;
        }
        return isBrokenFloor;
    }
    
    private{
        Cell[][] _cells;
        Vector2i _size;
        
        Vector2i _cursorPosition = Vector2i.zero;
        
        bool deleteFloor(in size_t n){
            if(n >= _cells.length){
                return false;
            }
            _cells = _cells[0..n] ~ _cells[n+1.._cells.length];
            return true;
        }
        
        ///
        void cursorPosition(in Vector2i p){
            if(p[0] < 0)return;
            if(p[0] >= _size[0])return;
            if(p[1] < 0)return;
            if(p[1] >= _size[1])return;
            _cursorPosition = p;
        }
    }
}
