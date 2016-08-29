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
        import game.resources;
        _hammer = (new armos.audio.Source).buffer(sounds("data/hammer"));
        _hammerBad = (new armos.audio.Source).buffer(sounds("data/cell_denied"));
        _click = (new armos.audio.Source).buffer(sounds("data/click"));
        _clickBad = (new armos.audio.Source).buffer(sounds("data/bad"));
    }
    
    ///
    void update(ref Entity[] entities){
        foreach (int f, floor; _cells) {
            foreach (int n, ref cell; floor) {
                cell.update(Vector2i(n, f)*Cell.size, entities);
            }
        }
        updateFoods;
        
        foreach (int f, floor; _cells) {
            bool isBrokenFloor = true;
            foreach (ref cell; floor) {
                isBrokenFloor = isBrokenFloor && cell.type == CellType.Broken;
            }
            if(isBrokenFloor) dropFloor(f);
        }
        
        if(_cells.length <= _cursorPosition[1])_cursorPosition[1]--;
    };
    
    ///
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
        import game.resources;
        version(Windows){
            int size = Cell.size * _cells.length;
            translate(cursorPosition[0]*Cell.size, cursorPosition[1]*Cell.size-size, 0);
        }else{
            popMatrix;
            pushMatrix;
            translate(cursorPosition[0]*Cell.size, cursorPosition[1]*Cell.size, 0);
        }
        animations("cursor", 1).index(0).draw;
        popMatrix;
    }
    
    ///
    void dropFloor(in size_t n){
        foreach (floor; _cells[n+1.._cells.length]) {
            foreach (ref cell; floor) {
                cell.dropEntity(Cell.size);
            }
        }
        
        deleteFloor(n);
        if(_cells.length == 0)addFloor;
        connectNearCells;
    }
    
    ///
    void connectEntitiesWithCell(ref Entity[] entities){
        //clear
        foreach (int f, floor; _cells) {
            foreach (int n, ref cell; floor) {
                cell.entities = [];
            }
        }
        
        foreach (entity; entities) {
            Cell* currentCell = &cell(Vector2i(entity.pos[0], entity.pos[1])/Cell.size);
            currentCell.entities ~= entity;
            entity.cell = currentCell;
        }
    }
    
    void connectNearCells(){
        foreach (int f, floor; _cells) {
            foreach (int n, ref cell; floor){
               if(f<_cells.length-1) cell.up = &_cells[f+1][n];
               if(0<f) cell.down = &_cells[f-1][n];
               if(n<floor.length-1) cell.right= &_cells[f][n+1];
               if(0<n) cell.left= &_cells[f][n-1];
            }
        }
    }

    ///
    ref Cell cell(in Vector2i position){
        return _cells[position[1]][position[0]];
    }
    
    ///
    Vector2i cursorPosition()const{
        return _cursorPosition;
    }
    
    ///
    void cursorMoveLeft(){
        cursorMove(Vector2i(-1, 0));
    }
    
    ///
    void cursorMoveRight(){
        cursorMove(Vector2i(1, 0));
    }
    
    ///
    void cursorMoveUp(){
        cursorMove(Vector2i(0, 1));
    }
    
    ///
    void cursorMoveDown(){
        cursorMove(Vector2i(0, -1));
    }
    
    ///
    void buildCellToCurrentCursor(in CellType type, in SoldierType soldierType = SoldierType.Infantry){
        if(cell(_cursorPosition).type != type){
            cell(_cursorPosition).type = type;
            cell(_cursorPosition).soldierType = soldierType;
            if(isFillFloor(_cells.length-1)){
                addFloor;
            }
            _hammer.play;
            return;
        }
        _hammerBad.play;
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
        connectNearCells;
    }
    
    ///
    bool isFillFloor(in size_t f)const{
        bool isNotEmptyFloor = true;
        foreach (ref cell; _cells[f]){
            isNotEmptyFloor = isNotEmptyFloor && cell.type != CellType.Empty;
        }
        return isNotEmptyFloor;
    }
    
    ///
    bool isBrokenFloor(in size_t f)const{
        bool isBrokenFloor = true;
        foreach (ref cell; _cells[f]){
            isBrokenFloor = isBrokenFloor && cell.type == CellType.Broken;
        }
        return isBrokenFloor;
    }
    
    ///
    bool isAnyDepotFloor(in size_t f)const{
        bool isDepotFloor = false;
        foreach (ref cell; _cells[f]){
            isDepotFloor = isDepotFloor || cell.type == CellType.Depot;
        }
        return isDepotFloor;
    }
    
    Vector2i size()const{
        import std.conv;
        return Vector2i(_cells[0].length.to!int, _cells.length.to!int);
    }
    
    ///
    float foods()const{
        return _foods;
    }
    
    void updateFoods(){
        import std.algorithm;
        _foods = 0f;
        _depots = [];
        foreach (int f, floor; _cells) {
            foreach (int n, ref cell; floor){
                if(cell.type == CellType.Depot){
                    _foods += cell.foods;
                    _depots ~= &cell;
                }
            }
        }
    }
    
    bool isExistAnyDepots()const{
        bool ret = false;
        import std.range;
        import std.array;
        foreach (i; _cells.length.iota.array) {
            ret = ret || isAnyDepotFloor(i);
        }
        return ret;
    }
    
    ///
    void decFoods(int num){
        import std.conv;
        float perDec = num / (_depots.length).to!float;
        foreach (ref depot; _depots) {
            depot.foods-=perDec;
        }
    }
    private{
        Cell[][] _cells;
        Vector2i _size;
        Cell*[] _depots;
        float _foods = 0f;
        armos.audio.Source _hammer;
        armos.audio.Source _hammerBad;
        armos.audio.Source _click;
        armos.audio.Source _clickBad;
        
        Vector2i _cursorPosition = Vector2i.zero;
        
        bool deleteFloor(in size_t n){
            if(n >= _cells.length){
                return false;
            }
            _cells = _cells[0..n] ~ _cells[n+1.._cells.length];
            return true;
        }
        
        ///
        void cursorMove(Vector2i p){
            import game.resources;
            Vector2i before = cursorPosition;
            cursorPosition = cursorPosition +  p;
            if(cursorPosition == before){
                _clickBad.play;
            }else{
                _click.play;
            }
        }
        
        ///
        void cursorPosition(in Vector2i p){
            if(p[0] < 0)return;
            if(p[0] >= _size[0])return;
            if(p[1] < 0)return;
            if(p[1] >= _cells.length)return;
            _cursorPosition = p;
        }
    }
}
