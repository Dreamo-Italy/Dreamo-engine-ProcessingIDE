 import grafica.*;
 
 class DebugPlot
{
 //************ CONSTANTS **************
 
  final int plotNumber = 8;
  
 //********* PUBLIC MEMBERS ***********


  //********* PRIVATE MEMBERS ***********
  private int nPoints = 300;
  private int nBars = 512;
  private int xSize, ySize;
  private GPointsArray [] points;
  private GPointsArray surfacePoints;
  private GPlot [] plots;
  
  private color bgColor,red,green,white;
  
  //********* CONSTRUCTOR ***********
  
  public DebugPlot(PApplet p)
  { 
    bgColor = color(1,1,1,10);
    white = color(0,0,100,50);
    red = color(0,60,60,50);
    green = color(50,50,50,50);
   
   // Prepare the points for the plots 
   points = new GPointsArray[plotNumber+1]; 
   // Create new plots 
   plots = new GPlot[plotNumber];
   surfacePoints = new GPointsArray(nPoints);
   
   ySize = (height - interlineSpace*6)/(2+(plotNumber-4));
   xSize = width/8;
   


   for(int i=0; i<plotNumber;i++)
   { 
     
     points[i] = new GPointsArray(nPoints);
   
     plots[i] = new GPlot(p);
  
     // Set the plots title and the axis labels
     //plots[i].setMar(new float[] {20, 20, 20, 20});
     //plots[i].setOuterDim(261,101);
     //plots[i].getXAxis().setAxisLabelText("x ");
     //plots[i].getYAxis().setAxisLabelText("y ");
     
     plots[i].setDim(xSize,ySize); 
     
     if(i<4)
     {
       plots[i].setPos(-marginSpace*4+30, interlineSpace*6+(i*(ySize+interlineSpace*2))); 
     }
     else
     {
       plots[i].setPos(-marginSpace*4+1030, interlineSpace*6+((i-4)*(ySize+interlineSpace*2)));
     }
   
     // Set the colors
     
     //plots[i].getYAxis().setAxisLabelText("y axis");
     plots[i].setPointSize(1);
     plots[i].setBoxBgColor(bgColor);
     plots[i].setBgColor(bgColor);
     plots[i].setLabelBgColor(red);
     plots[i].setBoxLineColor(bgColor);
     plots[i].setLineColor(red);
     plots[i].setPointColor(red);
     plots[i].getXAxis().setLineColor(green);
     plots[i].getYAxis().setLineColor(green);
     plots[i].setAllFontProperties("",white,11);


     for(int j=0; j<nPoints;j++)   
        points[i].add(frameCount, 0);
    
     plots[i].setPoints(points[i]);
     plots[i].getTitle().setOffset(-interlineSpace);
     plots[i].setFixedYLim(true);


     
   }
    
      
   plots[0].setTitleText("Gsr");
   plots[1].setTitleText("Ecg");
   plots[2].setTitleText("RMS");
   plots[3].setTitleText("Dynaicity Index");
   plots[4].setTitleText("Spectral Centroid");
   plots[5].setTitleText("Spectral Complexity");
   plots[6].setTitleText("Rhythm Strength");
   plots[7].setTitleText("Rhythm Density");
   

   
   plots[0].setYLim(0, 1);
   plots[1].setYLim(-1, 15);
   plots[2].setYLim(0, 1);
   plots[3].setYLim(0, 1);   
   plots[4].setYLim(0, 8000);
   plots[4].getYAxis().setFontSize(6);
   plots[5].setYLim(0, 100);
   plots[6].setYLim(0, 200);
   plots[7].setYLim(0, 10);
   


   
   for(int j=0; j<nPoints;j++)
     surfacePoints.add(frameCount, 0);
     
   // Change the second layer options - RMS
   plots[2].addLayer("AvgRMS", surfacePoints);
   plots[2].getLayer("AvgRMS").setPoints( surfacePoints );
   plots[2].getLayer("AvgRMS").setPointSize(1);
   plots[2].getLayer("AvgRMS").setPointColor( green ); 
   plots[2].getLayer("AvgRMS").setLineColor(green);   
   
   // Change the second layer options - DynIndex
   plots[3].addLayer("AvgDynIndex", surfacePoints);
   plots[3].getLayer("AvgDynIndex").setPoints( surfacePoints );
   plots[3].getLayer("AvgDynIndex").setPointSize(1);
   plots[3].getLayer("AvgDynIndex").setPointColor( green ); 
   plots[3].getLayer("AvgDynIndex").setLineColor(white);
   
   // Change the second layer options - Centroid
   plots[4].addLayer("AvgCentroid", surfacePoints);
   plots[4].getLayer("AvgCentroid").setPoints( surfacePoints );
   plots[4].getLayer("AvgCentroid").setPointSize(1);
   plots[4].getLayer("AvgCentroid").setPointColor( green ); 
   plots[4].getLayer("AvgCentroid").setLineColor(white);
   
   plots[5].addLayer("AvgComplexity", surfacePoints);
   plots[5].getLayer("AvgComplexity").setPoints( surfacePoints );
   plots[5].getLayer("AvgComplexity").setPointSize(1);
   plots[5].getLayer("AvgComplexity").setPointColor( green ); 
   plots[5].getLayer("AvgComplexity").setLineColor(white);
   
   plots[6].addLayer("AvgRhythmStrength", surfacePoints);
   plots[6].getLayer("AvgRhythmStrength").setPoints( surfacePoints );
   plots[6].getLayer("AvgRhythmStrength").setPointSize(1);
   plots[6].getLayer("AvgRhythmStrength").setPointColor( green ); 
   plots[6].getLayer("AvgRhythmStrength").setLineColor(white);
   
   plots[7].addLayer("AvgRhythmDensity", surfacePoints);
   plots[7].getLayer("AvgRhythmDensity").setPoints( surfacePoints );
   plots[7].getLayer("AvgRhythmDensity").setPointSize(1);
   plots[7].getLayer("AvgRhythmDensity").setPointColor( green ); 
   plots[7].getLayer("AvgRhythmDensity").setLineColor(white);


  }
  
  public void update()
  {
    addNewPoints();  
    removeOldestPoints();
    drawPlots();
  }
  
  public void addNewPoints()
  {
    plots[0].addPoint( frameCount, global_gsr.getNormalized());
    
    plots[1].addPoint( frameCount, global_ecg.getValue());
    
    plots[2].addPoint( frameCount, global_dyn.getRMS());    
    plots[2].getLayer("AvgRMS").addPoint( frameCount, audio_decisor.getFeturesVector()[0]);

    plots[3].addPoint( frameCount, global_dyn.getRMSStdDev());
    plots[3].getLayer("AvgDynIndex").addPoint(frameCount, audio_decisor.getFeturesVector()[1]);

    plots[4].addPoint( frameCount, global_timbre.getCentroidHz());    
    plots[4].getLayer("AvgCentroid").addPoint( frameCount, audio_decisor.getFeturesVector()[2]);
    
    plots[5].addPoint( frameCount, global_timbre.getComplexity());    
    plots[5].getLayer("AvgComplexity").addPoint( frameCount, audio_decisor.getFeturesVector()[3]);
    
    plots[6].addPoint( frameCount, global_rhythm.getRhythmStrength());    
    plots[6].getLayer("AvgRhythmStrength").addPoint( frameCount, audio_decisor.getFeturesVector()[4]);
    
    plots[7].addPoint( frameCount, global_rhythm.getRhythmDensity());    
    plots[7].getLayer("AvgRhythmDensity").addPoint( frameCount, audio_decisor.getFeturesVector()[5]);


  }
  
  public void removeOldestPoints()
  {
    for(int i=0; i<plotNumber;i++)
    {
      plots[i].removePoint(0);
    }    
    plots[2].getLayer("AvgRMS").removePoint(0);
    plots[3].getLayer("AvgDynIndex").removePoint(0);
    plots[4].getLayer("AvgCentroid").removePoint(0);
    plots[5].getLayer("AvgComplexity").removePoint(0);
    plots[6].getLayer("AvgRhythmStrength").removePoint(0);
    plots[7].getLayer("AvgRhythmDensity").removePoint(0);
   
    
  }
  
  public void drawPlots()
  {
     for(int i=0; i<plotNumber;i++)
    {        
      plots[i].defaultDraw();
    }
    plots[2].getLayer("AvgRMS").drawPoints();
    plots[3].getLayer("AvgDynIndex").drawPoints();
    plots[4].getLayer("AvgCentroid").drawPoints();
    plots[5].getLayer("AvgComplexity").drawPoints();
    plots[6].getLayer("AvgRhythmStrength").drawPoints();
    plots[7].getLayer("AvgRhythmDensity").drawPoints();
    
  }


}  