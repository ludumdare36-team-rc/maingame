module game.cell;
/**
 *
 */
enum CellType {
    Broken = -1,
    Empty = 0,
    House = 1,
    Ferm = 2,
    Factory = 3,
}
struct Cell{
    private int cellType = CellType.Empty;
    this(int cellType){
        this.cellType = cellType;
    }
    int getType(){
        return cellType;
    }
}
