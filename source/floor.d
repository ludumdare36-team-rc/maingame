module game.floor;
import game.cell;
/**
 *
 */
class Floor{
    Cell[] cells;
    this(Cell[] cell){
        this.cells = cell;
    }
    void add(Cell cell){
        cells ~= cell;
    }
    bool del(int n){
        if(n >= cells.length){
            return false;
        }
        cells = cells[0..n] ~ cells[n+1..cells.length];
        return true;
    }
    ref Cell get(int n){
        return cells[n];
    }
}
