import java.util.*;
import org.processing.wiki.triangulate.*;
import processing.pdf.*;
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
//import javax.swing.*; 
//import javax.swing.filechooser.*;
import java.awt.image.BufferedImage;

public int blur_val = 0;
public boolean displayImage = true;
public boolean displayMesh = false;
public boolean displayResult = false;
public boolean deleteMode = false;
public boolean displayBlurred = false;
public boolean displayLoupe = false;
public SmartBlurFilter smartFilter = new SmartBlurFilter();

public java.awt.Insets insets;  //"An Insets object is a representation of the borders of a container"

public int widthInsets;
public int heightInsets;


private ControlP5 cp5;

ControlFrame cf;
RadioButton r;
Toggle e; 
Toggle l;
Textarea ta;
//text file writer
PrintWriter output;
PGraphics pdf;

HashSet<Integer> chosenPointsList = new HashSet<Integer>();
ArrayList triangles = new ArrayList();
ArrayList<PVector> points = new ArrayList<PVector>();

PImage img, img_b, delCursor;



void setup()
{
  img = loadImage("Instructions.jpg");
  delCursor = loadImage("delcursor.png");
  img_b = img.get();

  size(img.width, img.height);

  insets = frame.getInsets();
  widthInsets = insets.left + insets.right;
  heightInsets = insets.top + insets.bottom;

  points.add(new PVector(0, 0, 0));
  points.add(new PVector(img.width, 0, 0));
  points.add(new PVector(img.width, img.height, 0));
  points.add(new PVector(0, img.height, 0));
  points.add(new PVector(img.width/2, img.height/2, 0));

  for (int i=0; i<points.size(); i++)
  {
    int pixelInteger = int(points.get(i).y*img.width + points.get(i).x); 
    chosenPointsList.add(pixelInteger);
  }

  noStroke();
  frameRate(24);
  cursor(CROSS);
  smooth();

  cp5 = new ControlP5(this);
  cf = addControlFrame("Tools", 230, 460);

  //noLoop();
}//end setup

void draw()
{
  if (displayImage == true)
  {
    image(img, 0, 0);
    noStroke();
    fill(0, 0, 255);
    for (int i=0; i< points.size(); i++)
    {
      ellipse((points.get(i)).x, (points.get(i)).y, 2, 2);
    }
    if (displayLoupe == true)
    {
      //copy(sx, sy, sw, sh, dx, dy, dw, dh)
      copy(mouseX - 10, mouseY - 10, 20, 20, 25, 25, 50, 50);
    }
  }//end if displayImage true

  if (displayBlurred == true)
  {
    image(img_b, 0, 0);
    noStroke();
    fill(0, 0, 255);
    for (int i=0; i< points.size(); i++)
    {
      ellipse((points.get(i)).x, (points.get(i)).y, 2, 2);
    }

    if (displayLoupe == true)
    {
      //copy(sx, sy, sw, sh, dx, dy, dw, dh)
      copy(mouseX - 10, mouseY - 10, 20, 20, 25, 25, 50, 50);
    }
  }//end if displayImage true

  if (displayMesh == true)
  {
    image(img, 0, 0);
    ArrayList<PVector> pointsTri = new ArrayList<PVector>(points); 
    triangles = Triangulate.triangulate(pointsTri);

    noFill();

    // draw the mesh of triangles
    beginShape(TRIANGLES);

    for (int i = 0; i < triangles.size(); i++) 
    {
      Triangle t = (Triangle)triangles.get(i);

      strokeJoin(BEVEL);
      strokeWeight(0.7);
      stroke(0, 0, 255);

      vertex(t.p1.x, t.p1.y);
      vertex(t.p2.x, t.p2.y);
      vertex(t.p3.x, t.p3.y);
    }
    endShape();

    if (displayLoupe == true)
    {
      //copy(sx, sy, sw, sh, dx, dy, dw, dh)
      copy(mouseX - 10, mouseY - 10, 20, 20, 25, 25, 50, 50);
    }
  }//end if displayResult true


  if (displayResult == true)
  {
    image(img_b, 0, 0);
    noStroke();

    ArrayList<PVector> pointsTri = new ArrayList<PVector>(points);    
    triangles = Triangulate.triangulate(pointsTri);

    for (int i = 0; i < triangles.size(); i++) 
    {
      Triangle t = (Triangle)triangles.get(i);

      int ave_x = int((t.p1.x + t.p2.x + t.p3.x)/3);  
      int ave_y = int((t.p1.y + t.p2.y + t.p3.y)/3);

      //strokeJoin(BEVEL);
      //strokeWeight(1.5);
      //stroke(img_b.get(ave_x,ave_y));
      fill( img_b.get(ave_x, ave_y), 255);

      triangle(t.p1.x, t.p1.y, t.p2.x, t.p2.y, t.p3.x, t.p3.y);
    }

    if (displayLoupe == true)
    {
      //copy(sx, sy, sw, sh, dx, dy, dw, dh)
      copy(mouseX - 10, mouseY - 10, 20, 20, 25, 25, 50, 50);
    }
  }//end if displayResult true
}//end draw

void mouseMoved()
{
  if (deleteMode == false)
  {
    noLoop();
    int pixelInteger = int(mouseY*img.width + mouseX);
    HashSet<Integer> chosenPointsHashA = new HashSet<Integer>(chosenPointsList); 
    HashSet<Integer> chosenPointsHashB = new HashSet<Integer>(chosenPointsList); 

    chosenPointsHashA.add(pixelInteger);

    if (chosenPointsHashA != chosenPointsHashB) 
    {
      points.set(points.size()-1, new PVector(mouseX, mouseY, 0));
    }
    loop();
  }
}
void mousePressed() 
{ 
  if (deleteMode == false && mouseEvent.getClickCount()< 2)
  {
    //long timer = System.currentTimeMillis();
    noLoop();  
    int pixelInteger = int(mouseY*img.width + mouseX);
    HashSet<Integer> chosenPointsHashA = new HashSet<Integer>(chosenPointsList); 
    HashSet<Integer> chosenPointsHashB = new HashSet<Integer>(chosenPointsList); 


    chosenPointsHashA.add(pixelInteger);

    if (chosenPointsHashA.size() != chosenPointsHashB.size()) 
    {
      points.add( new PVector(mouseX, mouseY, 0));
    }
    loop();
    //timer = System.currentTimeMillis()-timer;
    //System.out.println("mouse pressed "+timer+" ms");
  }

  if (deleteMode == true)
  {
    for (int i = 0; i<points.size(); i++)
    {
      float d = dist(mouseX, mouseY, points.get(i).x, points.get(i).y);
      if ( d < 5)
      {
        points.remove(i);
      }
    }
  }
} //end mousepressed




void mouseReleased() 
{
  frameRate(24);
}//end released

void keyPressed() 
{
  if (key == 's') 
  {
    PGraphics pdf = createGraphics(img.width, img.height, PDF, "output.pdf");
    pdf.beginDraw();
    pdf.noStroke();   
    pdf.image(img, 0, 0);
    ArrayList<PVector> pointsTri = new ArrayList<PVector>(points); 
    triangles = Triangulate.triangulate(pointsTri);
    for (int i = 0; i < triangles.size(); i++) 
    {
      Triangle t = (Triangle)triangles.get(i);

      int ave_x = int((t.p1.x + t.p2.x + t.p3.x)/3);  
      int ave_y = int((t.p1.y + t.p2.y + t.p3.y)/3);

      pdf.fill( img_b.get(ave_x, ave_y));

      pdf.triangle(t.p1.x, t.p1.y, t.p2.x, t.p2.y, t.p3.x, t.p3.y);
    }
    pdf.dispose();
    pdf.endDraw();
    save("output.tga");
  }

  if (key == 'o' || key == 'O') 
  {
    displayImage = true;
    displayMesh = false;
    displayResult = false;
    displayBlurred = false;
    r.activate(0);
  }

  if (key == 'r' || key == 'R') 
  {
    displayImage = false;
    displayMesh = false;
    displayResult = true;
    displayBlurred = false;
    r.activate(3);
  }

  if (key == 'b' || key == 'B') 
  {
    displayImage = false;
    displayMesh = false;
    displayResult = false;
    displayBlurred = true;
    r.activate(1);
  }

  if (key == 'm' || key == 'M') 
  {
    displayImage = false;
    displayMesh = true;
    displayResult = false;
    displayBlurred = false;
    r.activate(2);
  }

  if (key == 'l' || key == 'L') 
  {
    if (displayLoupe == true) 
    {
      displayLoupe = false;
      l.setState(false);
    }
    else if (displayLoupe == false) 
    {
      displayLoupe = true; 
      l.setState(true);
    }
  }

  if (key == 'e' || key == 'E') 
  {
    if (deleteMode == true) 
    {
      deleteMode = false;
      //points.add(new PVector(mouseX,mouseY,0)); 
      cursor(CROSS);
      e.setState(false);
      println("true");
    }
    else if (deleteMode == false) 
    {
      deleteMode = true; 
      //points.remove(points.size()-1);
      cursor(delCursor, 16, 16);
      e.setState(true);
      println("false");
    }
  }
}

/////////////////////////////////////////
//        BUTTON FUNCTIONS             //
/////////////////////////////////////////

public void eraser(boolean theFlag) 
{
  if (theFlag==true) 
  {
    deleteMode = true; 
    points.remove(points.size()-1);
    cursor(delCursor, 16, 16);
    println("false");
  } 
  else {
    deleteMode = false;
    points.add(new PVector(mouseX, mouseY, 0)); 
    cursor(CROSS);
    println("true");
  }
}


public void loupe(boolean theFlag) 
{
  if (theFlag==true) 
  {
    displayLoupe = true;
  } 
  else {
    displayLoupe = false;
  }
}

public void choose() 
{
  selectInput("Select a file to process:", "imageFileSelect");
} //end choose

public void lPoints() 
{
  selectInput("Select a points text file:", "pointsFileSelect");
} //end lPoints

public void sPoints() 
{
  selectOutput("Save points text file:", "pointsFileSave");
} //end sPoints

public void blur (int blur_value) {
  smartFilter.setRadius(int(blur_value)); 
  //println("a numberbox event. setting background to "+ blur_value);
}

public void threshold (float threshold_value) {
  smartFilter.setThreshold((threshold_value)); 
  //println("a numberbox event. setting background to "+ threshold_value);
}

public void blurIt () {
  if ( smartFilter.getRadius() != 0 && smartFilter.getThreshold() != 0)
  {
    noLoop();
    BufferedImage filtered = smartFilter.filter((BufferedImage) img.getNative());
    img_b = new PImage(filtered);
    loop();
  }
  else
  {
    img_b = img.get();
  }
  displayImage = false;
  displayBlurred = true;
  displayMesh = false;
  displayResult = false;
  r.activate(1);
}

public void passChooser(int a) 
{ 
  if (a == 1)
  {
    displayImage = true;
    displayBlurred = false;
    displayMesh = false;
    displayResult = false;
  }  

  if (a==2)
  {
    displayImage = false;
    displayBlurred = true;
    displayMesh = false;
    displayResult = false;
  }

  if (a==3)
  {
    displayImage = false;
    displayBlurred = false;
    displayMesh = true;
    displayResult = false;
  }

  if (a==4)
  {
    displayImage = false;
    displayBlurred = false;
    displayMesh = false;
    displayResult = true;
    ;
  }
}

public void savePDF()
{
  selectOutput("Save as a pdf:", "pdfFileSave");
}


/////////////////////////////////////////
//        OTHER FUNCTIONS              //
/////////////////////////////////////////

// version 2: create a look-up-table to skip duplicates.
int[] getUniqueValues_2(int src[], boolean return_sorted)
{
  int i, j, len = src.length;

  // get min and max values of source-array to get range.
  int max = src[0], min = src[0];
  for (i = 1; i < len; i++) {
    if ( src[i] > max) max = src[i];
    if ( src[i] < min) min = src[i];
  }
  int range = max-min+1;

  boolean[] flags  = new boolean[range]; // LUT for unique values
  int[]     unique = new int[range];     // contains unique values

  // save array-value to "unique" if the corresponding flag is not set yet.
  for (i = 0, j = 0; i < len; i++) {
    int val = src[i];
    int lut = val-min;
    if ( !flags[lut] )
    {
      unique[j++] = val;
      flags[lut] = true;
    }
  }

  unique = Arrays.copyOf(unique, j); // array may be smaller than range

  if (return_sorted) Arrays.sort(unique);

  return unique;
}//end get unique values

int[] ListToArray (ArrayList<Integer> src)
{
  //converts arraylist of integers to an array of int
  int[] result = new int[src.size()];
  for (int i=0; i < result.length; i++)
  {
    result[i] = (src.get(i)).intValue();
  }
  return result;
}//end list to array


void pdfFileSave(File selection)
{
  if (selection == null) 
  {
    ta.setColor(color(255));
    ta.setText("Status." + "\n" + "Nothing selected, no file saved.");
    //JOptionPane.showMessageDialog(this, "No file saved.", "Error!", JOptionPane.INFORMATION_MESSAGE);
  } 
  else
  {
    if (selection.getName().endsWith(".pdf"))
    {
      pdf = createGraphics(img.width, img.height, PDF, selection.getAbsolutePath());
    }// end if txt
    else
    {
      pdf = createGraphics(img.width, img.height, PDF, selection.getAbsolutePath()+".pdf");
    }// end else end with

    pdf.beginDraw();
    pdf.noStroke();   
    pdf.image(img, 0, 0);
    ArrayList<PVector> pointsTri = new ArrayList<PVector>(points); 
    triangles = Triangulate.triangulate(pointsTri);
    for (int i = 0; i < triangles.size(); i++) 
    {
      Triangle t = (Triangle)triangles.get(i);

      int ave_x = int((t.p1.x + t.p2.x + t.p3.x)/3);  
      int ave_y = int((t.p1.y + t.p2.y + t.p3.y)/3);
      pdf.fill( img_b.get(ave_x, ave_y));
      pdf.triangle(t.p1.x, t.p1.y, t.p2.x, t.p2.y, t.p3.x, t.p3.y);
    }
    pdf.dispose();
    pdf.endDraw();

    ta.setColor(color(0, 255, 0));
    ta.setText("Success." + "\n" + "The File was Saved Successfully!");

    //JOptionPane.showMessageDialog(this, "The File was Saved Successfully!", "Success!", JOptionPane.INFORMATION_MESSAGE);
  }//end else null
}// pdfFileSave


void pointsFileSave(File selection)
{
  if (selection == null) 
  {
    ta.setColor(color(255));
    ta.setText("Status." + "\n" + "Nothing selected, no file saved.");
    ///JOptionPane.showMessageDialog(this, "No file saved.", "Error!", JOptionPane.INFORMATION_MESSAGE);
  } 
  else
  {
    if (selection.getName().endsWith(".txt"))
    {
      output = createWriter(selection.getAbsolutePath());
    }// end if txt
    else
    {
      output = createWriter(selection.getAbsolutePath()+".txt");
    }// end else end with

    output.println((img.width) + " " + (img.height));
    for (int i =0 ; i < points.size(); i++)
    {
      output.println(points.get(i));
    }
    output.flush();  // Writes the remaining data to the file
    output.close();  // Finishes the file
    ta.setColor(color(0, 255, 0));
    ta.setText("Success." + "\n" + "The File was Saved Successfully!");
    //JOptionPane.showMessageDialog(this, "The File was Saved Successfully!", "Success!", JOptionPane.INFORMATION_MESSAGE);
  }//end else null
}// end pointsfilesave


void pointsFileSelect(File selection)
{
  if (selection == null) 
  {
    println("Window was closed or the user hit cancel.");
  } 
  else
  {
    if (selection.getName().endsWith("txt"))
    {
      // load the image using the given file path
      String lines[] = loadStrings(selection.getPath());     
      String[] width_height = split(lines[0], " ");
      if (parseFloat(width_height[0]) == img.width && parseFloat(width_height[1]) == img.height)
      {
        noLoop();
        points = new ArrayList<PVector>();
        chosenPointsList = new HashSet<Integer>();
        for (int i = 1; i < lines.length; i++)
        {
          String[] coords = split(lines[i], ", ");
          String[] coords_x = split(coords[0], "[ ");
          //println (coords);
          float x_ = parseFloat(coords_x[1]);
          float y_ = parseFloat(coords[1]);
          //println(lines[i]);
          points.add(new PVector(x_, y_, 0));
          int pixelInteger = int(y_*img.width + x_);
          chosenPointsList.add(pixelInteger);
        }
        loop();
        ta.setColor(color(0, 255, 0));
        ta.setText("Success." + "\n" + "Points are loaded.");
      }
      else {
        ta.setColor(color(255, 0, 0));
        ta.setText("Error." + "\n" + "Points file does not match the loaded image.");
        //JOptionPane.showMessageDialog(this, "Points file does not match the loaded image.", "Error!", JOptionPane.INFORMATION_MESSAGE);
      }
    }// end if txt
    else
    {
      ta.setColor(color(255, 0, 0));
      ta.setText("Error." + "\n" + "Please choose a txt file.");
      //JOptionPane.showMessageDialog(this, "Please choose a txt file.", "Error!", JOptionPane.INFORMATION_MESSAGE);
    }
  }//end else null
}//end pointsfileselction


void imageFileSelect(File selection) 
{
  if (selection == null) 
  {
    ta.setColor(color(255));
    ta.setText("Status." + "\n" + "Nothing selected, selection was cancelled.");
  } 
  else 
  {
    if (selection.getName().endsWith("jpg") || selection.getName().endsWith("jpeg") || selection.getName().endsWith("png") || selection.getName().endsWith("gif") || selection.getName().endsWith("tga") )
    {

      PImage checkImg = loadImage(selection.getAbsolutePath()); 
      // Check if loaded image is valid if invalid should return null or width/height -1
      if (checkImg != null && checkImg.width > 0 && checkImg.height > 0)  
      { 
        img = checkImg.get();

        String Scaled = ""; 
        String extension = "";

        int q = selection.getAbsolutePath().lastIndexOf('.');
        int p = Math.max(selection.getAbsolutePath().lastIndexOf('/'), selection.getAbsolutePath().lastIndexOf('\\'));

        if (q > p) {
          extension = selection.getAbsolutePath().substring(q+1);
        }


        //check image is 60px less than the display
        if (img.width + 60 > displayWidth || img.height + 60 > displayHeight)
        {
          float ratio = float(img.width)/float(img.height);
          println(ratio);
          int targetHeight = 0;
          int targetWidth = 0;

          if (img.width + 60 > displayWidth)
          {
            targetHeight = int((displayWidth- 60.0)/ratio);  
            targetWidth = displayWidth - 60;
          }
          if (img.height + 60 > displayHeight)
          {
            targetWidth = int((displayHeight - 60.0) * ratio);  
            targetHeight = displayHeight - 60;
          }

          PGraphics scaledImage = createGraphics(targetWidth, targetHeight);

          scaledImage.beginDraw();
          scaledImage.background(0, 0, 0, 0);
          scaledImage.image(img, 0, 0, targetWidth, targetHeight);
          scaledImage.endDraw();

          //println(extension);
          //println(selection.getAbsolutePath().substring(0,q));     

          scaledImage.save(selection.getAbsolutePath().substring(0, q)+"_scaled." + extension);
          img = loadImage(selection.getAbsolutePath().substring(0, q)+"_scaled." + extension);
          Scaled = (" Original image was too large for your display - scaled to fit and saved as " + selection.getAbsolutePath().substring(0, q)+"_scaled." + extension);
        }// end if img is bigger than display
        //println(selection.getAbsolutePath());
        img_b = img.get();
        // size the window and show the image 

        size(img.width + widthInsets, img.height + heightInsets);
        frame.setSize(img.width + widthInsets, img.height + heightInsets);

        //displayImg = img;
        //image(originalImg,0,0); 
        r.activate(0);

        chosenPointsList = new HashSet<Integer>();
        points = new ArrayList<PVector>();

        points.add(new PVector(0, 0, 0));
        points.add(new PVector(img.width, 0, 0));
        points.add(new PVector(img.width, img.height, 0));
        points.add(new PVector(0, img.height, 0));
        points.add(new PVector(img.width/2, img.height/2, 0));

        for (int i=0; i<points.size(); i++)
        {
          int pixelInteger = int(points.get(i).y*img.width + points.get(i).x); 
          chosenPointsList.add(pixelInteger);
        }

        displayImage = true;
        displayBlurred = false;
        displayMesh = false;
        displayResult = false;

        ta.setColor(color(0, 255, 0));
        ta.setText("Success." + "\n" + "Image file is loaded." + Scaled);
      } 
      else {
        ta.setColor(color(255, 0, 0));
        ta.setText("Error." + "\n" + "File chosen is not a valid image file.");
      }
    }  
    else
    {
      ta.setColor(color(255, 0, 0));
      ta.setText("Error." + "\n" + "Please choose an image file. (JPEG, JPG, PNG, TGA or GIF).");
      //JOptionPane.showMessageDialog(this, "Please choose an image file. (JPEG, JPG, PNG or GIF)", "Error!", JOptionPane.INFORMATION_MESSAGE);
    }
  }//end else selection
}// end image file selection

