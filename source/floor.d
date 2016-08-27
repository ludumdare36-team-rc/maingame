module game.floor;
import game.cell;
/**
 *
 */
struct Floor{
    private Cell[] cells;
    void cellSet(int n, Cell cell){
        cells ~= cell;
    }
    Cell cellRemove(int n){
        Cell cell = cells[n];
        cells = cells[0..n-1] ~ cells[n+1..cells.length];
        return cell;
    }
    Cell get(int n){
        return cells[n];
    }
}
