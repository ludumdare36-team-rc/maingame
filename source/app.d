static import ar = armos;
import game.animation;

class TestApp : ar.app.BaseApp{
    this(){}

    override void setup(){
		ar.graphics.blendMode = ar.graphics.BlendMode.Alpha;
        
        _animation = new Animation;
        _animation.load("bomb", 8);
        
		_rect = new ar.graphics.Mesh;
		_rect.primitiveMode = ar.graphics.PrimitiveMode.TriangleStrip;
		float x = 512;
		float y = 512;
		_rect.addTexCoord(0, 1);_rect.addVertex(0, 0, 0);
		_rect.addTexCoord(0, 0);_rect.addVertex(0, y, 0);
		_rect.addTexCoord(1, 1);_rect.addVertex(x, 0, 0);
		_rect.addTexCoord(1, 0);_rect.addVertex(x, y, 0);
		
		_rect.addIndex(0);
		_rect.addIndex(1);
		_rect.addIndex(2);
		_rect.addIndex(3);
        _animation.currentIndex = 2;
    }

    override void update(){}

    override void draw(){
		_animation.begin;
		_rect.drawFill;
		_animation.end;
    }

    override void keyPressed(ar.utils.KeyType key){}

    override void keyReleased(ar.utils.KeyType key){}

    override void mouseMoved(ar.math.Vector2i position, int button){}

    override void mousePressed(ar.math.Vector2i position, int button){}

    override void mouseReleased(ar.math.Vector2i position, int button){}

    private{
        Animation _animation;
        ar.graphics.Mesh _rect;
    }
}

void main(){ar.app.run(new TestApp);}
