ControlFrame addControlFrame(String theName, int theWidth, int theHeight) 
{
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(50, 50);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}


// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded

public class ControlFrame extends PApplet 
{
  int w, h;
  //int abc = 100;
  ControlP5 cp5;
  Object parent;
  
  
  public void setup() 
  {
    size(w, h);
    frameRate(25);
    
    cp5 = new ControlP5(this);
    
    
    cp5.addButton("choose")
     .setPosition(10,10)
     .setSize(200,20)
     .plugTo(parent,"choose")
     .setLabel("Choose an Image...")
     ;
     
    cp5.addSlider("blur")
     .setPosition(10,50)
     .setSize(90,20)
     .setRange(0,20)
     .setValue(5)
     .setLabel("Blur Radius")
     .plugTo(parent,"blur")
     ;
  
    cp5.addSlider("threshold")
     .setPosition(10,80)
     .setSize(90,20)
     .setRange(0,255)
     .setValue(10)
     .setLabel("Threshold")
     .plugTo(parent,"threshold")
     ;
     
    cp5.addButton("blurIt")
     .setPosition(10,110)
     .setSize(90,20)
     .plugTo(parent,"blurIt")
     .setLabel("Blur")
     ;
   
   
   cp5.addButton("sPoints")
     .setPosition(10,150)
     .setSize(90,20)
     .plugTo(parent,"sPoints")
     .setLabel("Save Points")
     ;
  
  cp5.addButton("lPoints")
     .setPosition(120,150)
     .setSize(90,20)
     .plugTo(parent,"lPoints")
     .setLabel("Load Points")
     ;
     
  e = cp5.addToggle("eraser")
     .plugTo(parent,"eraser")
     .setPosition(10,180)
     .setSize(90,20)
     .setLabel("On/Off Eraser (e)")
     ;
     
  l = cp5.addToggle("loupe")
     .plugTo(parent,"loupe")
     .setPosition(120,180)
     .setSize(90,20)
     .setLabel("Show/Hide Loupe (l)")
     ;
     
 r = cp5.addRadioButton("passChooser")
     .setPosition(10,240)
     .setSize(20,20)
     .setItemsPerRow(2)
     .setSpacingColumn(90)
     .setSpacingRow(10)
     .addItem("original (o)",1)
     .addItem("blurred (b)",2)
     .addItem("mesh (m)",3)
     .addItem("result (r)",4)
     .activate(0)
     .plugTo(parent,"passChooser")
     ;    

  cp5.addButton("savePDF")
     .setPosition(10,320)
     .setSize(200,20)
     .setLabel("Write to PDF")
     .plugTo(parent,"savePDF")
     ;
     
   // cp5.addSlider("abc").setRange(0, 255).setPosition(10,10);
   // cp5.addSlider("def").plugTo(parent,"def").setRange(0, 255).setPosition(10,30);
   
   ta = cp5.addTextarea("txt")
      .setPosition(10,360)
      .setSize(200,60)
      .setLineHeight(14)
      .setColor(color(255))
      .setColorBackground(color(2,52,77))
      .setBorderColor(color(2,52,77))
      .setText("Message Window")
    ;
  }

  public void draw() {
      background(100);
  }
  
  private ControlFrame() {}

  public ControlFrame(Object theParent, int theWidth, int theHeight) 
  {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }

  public ControlP5 control() 
  {
    return cp5;
  }

}
