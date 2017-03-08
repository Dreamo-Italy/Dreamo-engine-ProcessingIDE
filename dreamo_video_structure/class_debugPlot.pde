 class DebugPlot
{
 //************ CONSTANTS **************
 
  final int plotNumber = 3;
  
 //********* PUBLIC MEMBERS ***********


  //********* PRIVATE MEMBERS ***********
  private int nPoints = 300;
  private GPointsArray [] points;
  private GPointsArray surfacePoints;
  private GPlot [] plots;
  
  //********* CONSTRUCTOR ***********
  
  public DebugPlot(PApplet p)
  {   
   
   // Prepare the points for the plots 
   points = new GPointsArray[plotNumber+1]; 
   // Create new plots 
   plots = new GPlot[plotNumber];
   
   surfacePoints = new GPointsArray(nPoints);

   for(int i=0; i<plotNumber;i++)
   { 
     
   points[i] = new GPointsArray(nPoints);
   plots[i] = new GPlot(p);
   plots[i].setPos(0, height-(i*130)-100);
  
   // Set the plots title and the axis labels
   plots[i].setMar(new float[] {50, 20, 50, 0});
   plots[i].setOuterDim(281,91);
   plots[i].setDim(250,80);
   //plots[i].getXAxis().setAxisLabelText("x ");
   //plots[i].getYAxis().setAxisLabelText("y ");
   
   // Set the colors
   color bgColor = color(1,1,1,20);
   color red = color(0,60,60,60);
   plots[i].setFixedYLim(true);
   plots[i].setYLim(0, 1);
   plots[i].getYAxis().setAxisLabelText("y axis");
   plots[i].setPointSize(1);
   plots[i].setBoxBgColor(bgColor);
   plots[i].setBgColor(bgColor);
   plots[i].setLabelBgColor(bgColor);
   plots[i].setBoxLineColor(bgColor);
   plots[i].setLineColor(red);
   plots[i].setPointColor(red);
   plots[i].getXAxis().setLineColor(red);
   plots[i].getYAxis().setLineColor(red);

   for(int j=0; j<nPoints;j++)   
      points[i].add(frameCount, 0);

    plots[i].setPoints(points[i]);
     
   }
      
   plots[0].setTitleText("Gsr");
   plots[1].setTitleText("Ecg");
   plots[2].setTitleText("RMS");
   
   for(int j=0; j<nPoints;j++)
     surfacePoints.add(frameCount, 0);
     
   plots[2].addLayer("AvgRMS", surfacePoints);
   plots[2].getLayer("AvgRMS").setPoints( surfacePoints );
   plots[2].getLayer("AvgRMS").setPointSize(1);
   plots[2].getLayer("AvgRMS").setPointColor( color(50,50,50,50) );

  // Change the second layer line color
  plots[2].getLayer("AvgRMS").setLineColor(color(50,50,50,50));
  
  }
  
  public void update()
  {
    if ( global_gsr.isCalibrating() == false ){
    plots[0].addPoint( frameCount, global_gsr.getAbsolute() );
    plots[1].addPoint( frameCount, global_ecg.getAbsolute() );
    plots[2].addPoint( frameCount, global_dyn.getRMS() );
    
    plots[2].getLayer("AvgRMS").addPoint( frameCount, global_dyn.getAvgRMS() );
    
    plots[2].getLayer("AvgRMS").removePoint(0);
    plots[2].getLayer("AvgRMS").drawPoints();
    
    
      
       for(int i=0; i<plotNumber;i++)
      {                 
        plots[i].removePoint(0);
      
        // Draw it!
        plots[i].defaultDraw();
      }
    }
  }
}  