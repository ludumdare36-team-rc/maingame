module game.tower;

import game.floor;
import game.cell;
import armos.math;

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
    
    // ///
    // void addFloor(Floor floor){
    //     _floors ~= floor;
    // }
    
    ///
    void update(){
        import std.stdio;
        _cells.length.writeln;
        _cells[0].length.writeln;
        
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
    }
    
    void dropFloor(in size_t n){
        foreach (floor; _cells[n+1.._cells.length]) {
            foreach (ref cell; floor) {
                cell.dropEntity(Cell.size);
            }
        }
        
        deleteFloor(n);
    }

    
    Cell cell(in Vector2i position){
        return _cells[position[1]][position[0]];
    }
    
    private{
        Cell[][] _cells;
        Vector2i _size;
        
        bool deleteFloor(in size_t n){
            if(n >= _cells.length){
                return false;
            }
            _cells = _cells[0..n] ~ _cells[n+1.._cells.length];
            return true;
        }
    }
}
