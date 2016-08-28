module game.entity;
import armos.math.vector;
import game.cell;

enum EntityType{
    Resident,
    Soldier,
    Enemy, 
}

interface Entity{
    EntityType type()const;
    bool shouldDie();
    int age();
    Vector3i pos();
    void pos(in Vector3i);
    int life();
    void damage(in int);
    
    void setup();
    void update(in Vector2i towerSize);
    void draw();
    void cell(Cell*);
}
