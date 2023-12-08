import processing.serial.*;
import de.looksgood.ani.*;

//アニメーションを行うオブジェクト
AniSequence seq;

//描画される円に関する変数
boolean redBallVisible, blueBallVisible;
boolean boxVisible;
int ballSize = 80;
int box_x, box_y;
float red_x,red_y;
float blue_x, blue_y;

void setup() {  
  //描画の基本設定
  size(800, 600);
  //fullScreen(); //発表はフルスクリーンで行うこと
  noStroke();
  smooth();
  ellipseMode(CENTER);
  
  //描画する円の初期化
  redBallVisible = true;
  blueBallVisible = false;
  red_x = width/2;
  red_y = -ballSize/2;
  blue_x = width/2;
  blue_y = height-ballSize/2;
  
  //描画する箱の初期化
  boxVisible = true;
  //box_x = width/5;
  //box_y = 2*height/5;
  
  /*
  //Arduino設定
  if(arduinoOn){
    printArray(Serial.list()); // 使用可能なシリアルポート一覧の出力。デバッグ用
    String portName = Serial.list()[0]; // 使用するシリアルポート名
    serialPort = new Serial(this, portName, 9600);
    serialPort.buffer(inByte.length); // 読み込むバッファの長さをの指定
    initServo();
  }
  */
  
  //必ず最初にinit()を実行すること。
  Ani.init(this);
  
  
  //beginSequence()からendSequence()までを一連のアニメーションとして登録
  seq = new AniSequence(this);
  seq.beginSequence();
  
  // step 0
  seq.add(Ani.to(this, 2, "red_y", height-ballSize/2, Ani.BOUNCE_OUT));

  // step 1 (一度に二つ以上のAni.to()を実行したいときはbiginStep()とendStep()で囲む)
  //Ani.to(対象の変数をフィールドに持つオブジェクト, 秒数, 対象の変数名, 目標値);
  seq.beginStep();
  seq.add(Ani.to(this, 2, "red_x", width/4*1, Ani.EXPO_IN_OUT));
  seq.add(Ani.to(this, 2, "blue_x", width/4*3,  Ani.EXPO_IN_OUT, "onStart:showBlueBall"));
  seq.endStep();
  
  // step 2
  seq.beginStep();
  seq.add(Ani.to(this, 2, "red_x", width+ballSize/2, Ani.EXPO_IN_OUT));
  seq.add(Ani.to(this, 2, "red_y:200", Ani.EXPO_IN_OUT, "onEnd:moveServo1"));
  seq.endStep();
    
  // step 3
  seq.beginStep();
  seq.add(Ani.to(this, 2, "blue_x", width+ballSize/2, Ani.EXPO_IN_OUT));
  seq.add(Ani.to(this, 2, "blue_y:300", Ani.EXPO_IN_OUT, "onEnd:moveServo2"));
  seq.endStep();

  seq.endSequence();  
}

void draw() { 
  // 初期描画
  background(255);
  fill(0);
  
  //円を描画
  //xとyはAni.to()によって変化する
  if(blueBallVisible){
    fill(0,0,255);
    ellipse(blue_x, blue_y, ballSize, ballSize);
  }
  if(redBallVisible){
    fill(255,0,0);
    ellipse(red_x, red_y, ballSize, ballSize);
  }
  
  /*
  if(arduinoOn){
    text("oval1: "+oval1, 10, 20); // デバッグ用。発表時には非表示にすること
    text("oval2: "+oval2, 10, 40); // デバッグ用。発表時には非表示にすること
  }
  */
  
  if(boxVisible){
    fill(255);
    stroke(0);
    rect(width/5, 2*height/5, 2.5*width/5, 2.5*height/5);
    
    beginShape();
    vertex(3.5*width/5,2*height/5);
    vertex(3.5*width/5,4.5*height/5);
    vertex(3.5*width/5+width/10,4.5*height/5-height/20);
    vertex(3.5*width/5+width/10,2*height/5-height/20);
    endShape();
    
    beginShape();
    vertex(width/5,2*height/5);
    vertex(width/5,2*height/5);
    vertex(width/5,2*height/5);
    vertex(width/5,2*height/5);
    endShape(CLOSE);
  }
}

/*
void mousePressed(){
  if(mouseButton == LEFT){
    reset();
  } else if(mouseButton == RIGHT){
    if(blueBallVisible){
      reset();
    }
    seq.start(); // start the whole sequence
  }
}
*/
/*
//アニメーションリセット
void reset() {
  blueBallVisible = true;
  if(arduinoOn){
    initServo();
  }  
}

//Step1開始時に呼び出される。
//青いボールを出現させる。
void showBlueBall(){
  blueBallVisible = true;
}
*/
