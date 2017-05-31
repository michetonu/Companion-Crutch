// Code by Michele Tonutti, based on the GWOptics library and examples.
// Draw a rolling graph of sensor data from an Arduino connected to a sensorised crutch.

import processing.serial.*; 
import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;

String xAxis;
String Force;
String accelReadings;
String splitReadings[];
float xData;
String portName = Serial.list()[5];

Serial myPort;
RollingLine2DTrace rx;
RollingLine2DTrace Fx;
Graph2D g;
Graph2D f;
int t=0;

void setup(){
 size(1200,800);
       println(Serial.list());
 myPort = new Serial(this, portName, 9600);
 myPort.write(1); //request data string
 myPort.bufferUntil('\n');


 Fx = new RollingLine2DTrace(new eq_F(),20,.025f);
 Fx.setTraceColour(0, 0, 255);

 f = new Graph2D(this, 1000, 300, false);
 f.setYAxisMin(0);
 f.setYAxisMax(500);
 f.addTrace(Fx);
 f.position.y = 400;
 f.position.x = 100;
 f.setYAxisTickSpacing(50);
 f.setXAxisTickSpacing(1);
 f.setXAxisMax(20f);
 f.setYAxisLabel("Force (N)");
 f.setXAxisLabel("Time (s)");
  
 rx  = new RollingLine2DTrace(new eq_x(),20,.025f);
 rx.setTraceColour(255, 0, 0);
        
 g = new Graph2D(this, 1000, 300, false);
 g.setYAxisMax(20);
 g.setYAxisMin(-30);
 g.addTrace(rx);
 g.position.y = 50;
 g.position.x = 100;
 g.setYAxisTickSpacing(5);
 g.setXAxisTickSpacing(1);
 g.setXAxisMax(20f);
 g.setYAxisLabel("Tilt (º)");
 g.setXAxisLabel("Time (s)");
 
}

void draw(){
  t++;
  
  background(255);
  g.draw(); 
  f.draw();
}



class eq_x implements ILine2DEquation{
 public double computePoint(double x,int pos) {
    
    String accelReadings =myPort.readStringUntil('\n');   //genData();
    if(accelReadings != null){
      String [] splitReadings = splitTokens(accelReadings, " ,");
      xAxis = splitReadings[0];
      
    }
    return float(xAxis);   
 } 
}

class eq_F implements ILine2DEquation{
 public double computePoint(double x,int pos) {
//    myPort.write(1); //request data string
//    readSerialData();//read, split, and update stored values
String accelReadings =myPort.readStringUntil('\n');   //genData();
    if(accelReadings != null){
      String [] splitReadings = splitTokens(accelReadings, " ,");
      if (splitReadings.length == 2){
       Force = splitReadings[1];
    } 
    }
    return float(Force);   
 } 
}
