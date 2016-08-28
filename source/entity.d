module game.entity;
import armos.math.vector;
import game.cell;

interface Entity{
    bool shouldDie();
    int age();
    Vector3i pos();
    void pos(in Vector3i);
    int life();
    
    void setup();
    void update(in Vector2i towerSize);
    void draw();
    void cell(Cell*);
}
