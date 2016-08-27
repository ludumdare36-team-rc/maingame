module game.resources;
import armos.audio.buffer;
import game.animation;

private Animation[string] animationResources;

Animation animations(in string name, in size_t count){
    import std.algorithm;
    bool isNew = animationResources.keys.find(name) == [];
    if(isNew){
        Animation animation = new Animation(name, count);
        animationResources[name] = animation;
        return animation;
    }else{
        return animationResources[name];
    }
}

///
Animation animations(in string name){
    import std.algorithm;
    bool isNew = animationResources.keys.find(name) == [];
    if(isNew){
        Animation animation = new Animation(name);
        animationResources[name] = animation;
        return animation;
    }else{
        return animationResources[name];
    }
}

private Buffer[string] soundResources;

///
Buffer sounds(in string name){
    import std.algorithm;
    bool isNew = soundResources.keys.find(name) == [];
    if(isNew){
        Buffer sound = (new Buffer()).load(name ~ ".ogg");
        soundResources[name] = sound;
        return sound;
    }else{
        return soundResources[name];
    }
}
