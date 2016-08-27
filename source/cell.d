module game.cell;
/**
 *
 */
enum CellType {
    Broken,
    Empty,
    House,
    Ferm,
    Factory,
}
struct Cell{
    private int cellType = CellType.Empty;
    this(int cellType){
        this.cellType = cellType;
    }
    int getType(){
        return cellType;
    }
    void brake(){
        cellType = CellType.Broken;
    }
}
