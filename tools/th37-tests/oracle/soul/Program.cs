// 原作无图形轨迹探针：角色免伤，其他游戏接口只供编译；反弹一旦调用即报错。
using System;using System.IO;using System.Collections.Generic;
namespace Microsoft.Xna.Framework {
[Serializable]public struct Vector2 {public float X,Y;public Vector2(float x,float y){X=x;Y=y;}public static Vector2 Zero=>new(0,0);public void Normalize(){float n=1/(float)Math.Sqrt(X*X+Y*Y);X*=n;Y*=n;}public static Vector2 operator+(Vector2 a,Vector2 b)=>new(a.X+b.X,a.Y+b.Y);public static Vector2 operator-(Vector2 a,Vector2 b)=>new(a.X-b.X,a.Y-b.Y);public static Vector2 operator*(Vector2 a,float b)=>new(a.X*b,a.Y*b);public static Vector2 operator/(Vector2 a,float b)=>new(a.X/b,a.Y/b);}
public struct Rectangle {public int X,Y,Width,Height;public Rectangle(int x,int y,int w,int h){X=x;Y=y;Width=w;Height=h;}}
public struct Color{}
public static class MathHelper {public static float ToRadians(float a)=>a*0.0174532924f;public static float ToDegrees(float a)=>a*57.29578f;public static float Clamp(float x,float a,float b)=>Math.Min(b,Math.Max(a,x));public static float Lerp(float a,float b,float t)=>a+(b-a)*t;}
}
namespace Microsoft.Xna.Framework.Graphics {public class GraphicsDevice{}public class Texture2D{public static Texture2D FromStream(GraphicsDevice g,Stream s)=>new();}public class SpriteBatch{}}
namespace THMHJ {
using Microsoft.Xna.Framework;using Microsoft.Xna.Framework.Graphics;
public enum GameMode{SPECIAL}
public static class Cry {public static Stream Decry(string file,int k)=>File.OpenRead("raw/"+Path.GetFileName(file));public static Stream CSDecry(string file)=>new MemoryStream();}
public static class Main {public static Random rand=new(20261119);public static GameMode GameMode;public static bool CheckTwoLineCrose(Line a,Line b)=>throw new NotSupportedException();public static double Rand(bool bomb)=>rand.NextDouble();public static float Twopointangle(float x2,float y2,float x1,float y1){float n=(float)Math.Atan((y2-y1)/(x2-x1==0?x2-x1+.1f:x2-x1));if(x2-x1<0)n+=(float)Math.PI;return n;}}
public class Sprite {public Vector2 position;}
public class Character {public Sprite body=new();public Vector2 rangex=new(32,416),rangey=new(16,463);public bool free=true,Dis,BWudi,SWudi;public int time;public void Grazed(){}}
public class Enemy {public Vector2 Position;public int hp;public bool die;public bool IsInWudi()=>false;}
public class EnemyManager {public List<Enemy> EnemyArray=new();}
public class BossCard {public void DeHp(int hp,bool s){}}
public class Boss {public Vector2 Position=new(222,188);public List<BossCard> CardArray=new();public bool IsInWudi()=>false;public void Setpos(float x,float y){Position=new(x,y);}}
public class Game {public SakuraStatus SakuraStatus;public Vector2 quake;public long Score;public void PlaySound(string name,bool apply3d,float x){}public void SmallItem(Vector2 p){}public void AddGraze(float x){}public CrazyStorm PlayEffect(bool add,string id,Vector2 p)=>null;}
public class Program {public static Program main=new();public Game game=new();public static void Main(){for(int mode=1;mode<=3;mode++){System.Globalization.CultureInfo.CurrentCulture=System.Globalization.CultureInfo.InvariantCulture;var csm=new CSManager(null,null,null);var p=new Character();p.body.position=new(224,420);var boss=new Boss();var cs=new CrazyStorm(null,csm,true,"b652",new(317,407));if(cs.layerm.LayerArray.Exists(l=>l.LaseArray.Count!=0||l.ReboundArray.Count!=0))throw new Exception("探针不覆盖激光或反弹板");csm.csc.Add(cs);for(int tick=1;tick<=880;tick++){
if(mode==2){int a=tick%160,z=tick%120;p.body.position=new(224+(a<80?a-40:120-a),400+(z<60?z-30:90-z)*.5f);}
if(mode==3&&tick>=560){var lamp=cs.layerm.LayerArray[2].Barrages.Find(b=>b.parentid==5&&b.life>0&&!b.NeedDelete);if(lamp!=null){var delta=new Vector2(lamp.x-93,lamp.y+13)-p.body.position;float length=(float)Math.Sqrt(delta.X*delta.X+delta.Y*delta.Y);if(length>3.5f)delta=delta/length*3.5f;p.body.position+=delta;}}
Console.WriteLine(string.Join("\t","P",mode,tick,p.body.position.X.ToString("R"),p.body.position.Y.ToString("R")));
cs.SetPos(boss.Position+new Vector2(93,-13),false);cs.Update(p,new EnemyManager(),boss);foreach(var layer in cs.layerm.LayerArray){foreach(var b in layer.Barrages){if(!b.NeedDelete&&layer.sort==2&&(b.parentid==5||b.parentid==6||b.parentid==8))Console.WriteLine(string.Join("\t","B",mode,tick,b.parentid,b.time,b.x.ToString("R"),b.y.ToString("R"),b.speedx.ToString("R"),b.speedy.ToString("R"),b.speed.ToString("R"),b.speedd.ToString("R"),b.head.ToString("R"),b.life));}layer.Barrages.RemoveAll(b=>b.NeedDelete);}}}}}
}
