using System;using System.Collections.Generic;using System.Text.Json;
namespace Microsoft.Xna.Framework {
public struct Vector2 {public float X,Y;public Vector2(float x,float y){X=x;Y=y;}public static Vector2 Zero=>new(0,0);public static Vector2 One=>new(1,1);public void Normalize(){float n=1/(float)Math.Sqrt(X*X+Y*Y);X*=n;Y*=n;}public static Vector2 operator+(Vector2 a,Vector2 b)=>new(a.X+b.X,a.Y+b.Y);public static Vector2 operator-(Vector2 a,Vector2 b)=>new(a.X-b.X,a.Y-b.Y);public static Vector2 operator*(Vector2 a,float b)=>new(a.X*b,a.Y*b);public static Vector2 operator/(Vector2 a,float b)=>new(a.X/b,a.Y/b);}
public struct Rectangle {public int X,Y,Width,Height;public Rectangle(int x,int y,int w,int h){X=x;Y=y;Width=w;Height=h;}}
public static class MathHelper {public static float ToRadians(float a)=>a*0.0174532924f;public static float ToDegrees(float a)=>a*57.29578f;}
}
namespace Microsoft.Xna.Framework.Graphics {public class Texture2D{}public class SpriteBatch{}public enum SpriteEffects {None}}
namespace Microsoft.Xna.Framework.Input {public enum Keys{Z,LeftShift,RightShift}}
namespace THMHJ {
using Microsoft.Xna.Framework;using Microsoft.Xna.Framework.Graphics;using Microsoft.Xna.Framework.Input;
public enum Cname{None,REIMU,MARISA,SANAE,YOUMU}public enum JOYKEYS{ShootOrConfirm,Slow}
public class Colors{public float r,g,b,a;public Colors(float r,float g,float b,float a){this.r=r;this.g=g;this.b=b;this.a=a;}}
public class Sprite {public Vector2 position,origin;public Vector2 scale=Vector2.One;public Colors color=new(1,1,1,1);public Rectangle rect;public float rotation;public Sprite(Texture2D t,Rectangle r){}public void Draw(SpriteBatch s,SpriteEffects e,float f){}}
public static class Time {public static float Stop=1;}
public static class Main {public static bool Replay=true;public static bool Slow,Shoot;public static bool IsKeyDown(Keys key)=>key==Keys.Z?Shoot:Slow;public static bool IsKeyUp(Keys key)=>!IsKeyDown(key);public static bool IsPreKeyDown(Keys key)=>IsKeyDown(key);public static object prepadstat=new();}
public static class PadState {public static bool IsKeyDown(JOYKEYS k)=>false;public static bool IsKeyUp(JOYKEYS k)=>true;public static bool IsPreKeyDown(JOYKEYS k,object p)=>false;}
public class Boss{public void JudgeRay(Vector2 p,Vector2 d,float power){}}public class EnemyManager{public void JudgeRay(Vector2 p,Vector2 d,float power){}}
public class SelfBarrage {public Rectangle rect;public Vector2 Position,origin,scale;public Colors color=new(1,1,1,0);public float alpha,speed,speedd,power,dx,dy;public int label;public bool straight,ignore,chase,rotate,instantDead,Judged;}
public class SelfBarrageManager {public static List<SelfBarrage> SBArray=new();public static SelfBarrage Get(Texture2D t,Rectangle r,Vector2 o,Vector2 p,float e,float a,Vector2 s){var b=new SelfBarrage{rect=r,Position=p,origin=o,scale=s,alpha=a};SBArray.Add(b);return b;}}
public class CrazyStorm {public string Id="";public List<byte> shoot=new();public bool isforshoot,effect,bomb,specialnotkill,allpan;public void UnderBarrage(){}public void BanSound(bool b){}public void SetOPos(Vector2 p){}public void SetPos(Vector2 p,bool all=false){}public void Break(){}}
public class Game {public List<CrazyStorm> Crazystorms=new();public CrazyStorm PlayEffect(bool add,string id,Vector2 pos){var cs=new CrazyStorm{Id="e"+id};Crazystorms.Add(cs);return cs;}public CrazyStorm FindEffect(string id)=>Crazystorms.Find(c=>c.Id=="e"+id);public void StopSound(string name){}public void PlaySound(string name,bool apply3d,float x){}}
internal class Driver:Equipment {public Driver(Texture2D tex):base(tex){}public void Fire(Texture2D t,Cname c,Vector2 p)=>BEquipShoot(t,c,p);}
public class Program {public static Program main=new();public Game game=new();public static void Main(){for(int m=1;m<=3;m++)for(int l=1;l<=4;l++){SelfBarrageManager.SBArray.Clear();var tex=new Texture2D();var o=new Driver(tex);o.Init();for(int t=1;t<=120;t++){THMHJ.Main.Shoot=t<100;THMHJ.Main.Slow=t>=40&&t<=80;var pos=new Vector2(224,420);o.Update(null,new EnemyManager(),(Cname)m,l,pos,false);if(THMHJ.Main.Shoot)o.Fire(tex,(Cname)m,pos);}foreach(var b in SelfBarrageManager.SBArray)Console.WriteLine(string.Join("\t",m,l,b.rect.X,b.rect.Y,b.rect.Width,b.rect.Height,b.Position.X.ToString("R"),b.Position.Y.ToString("R"),b.power.ToString("R"),b.speed.ToString("R"),b.speedd.ToString("R"),b.scale.X.ToString("R"),b.scale.Y.ToString("R")));}}}
}
