 import grafica.*;

 class DebugPlot 
 {
  //************ CONSTANTS **************

  final int plotNumber = 11; 

  //********* PUBLIC MEMBERS ***********


  //********* PRIVATE MEMBERS ***********
  private int nPoints = 300;
  //private int nBars = 512;
  private int xSize, ySize;
  private GPointsArray[] points;
  private GPointsArray surfacePoints;
  private GPlot[] plots;

  private color bgColor, red, green, white, violet;

  //********* CONSTRUCTOR ***********

  public DebugPlot(PApplet p) 
  {
   bgColor = color(1, 1, 1, 10);
   white = color(30, 20, 100, 100);
   red = color(8, 76, 90, 100);
   violet = color(320, 30, 80, 100);
   green = color(69, 76, 76, 100);

   // Prepare the points for the plots 
   points = new GPointsArray[plotNumber + 1];
   // Create new plots 
   plots = new GPlot[plotNumber];
   surfacePoints = new GPointsArray(nPoints);

   ySize = (height - interlineSpace * 6) / (2 + (8 - 4)); // al posto di 8 c'era plotNumber.
   xSize = width / 8;

   for (int i = 0; i < plotNumber; i++) 
   {

    points[i] = new GPointsArray(nPoints);

    plots[i] = new GPlot(p);

    // Set the plots title and the axis labels
    //plots[i].setMar(new float[] {20, 20, 20, 20});
    //plots[i].setOuterDim(261,101);
    //plots[i].getXAxis().setAxisLabelText("x ");
    //plots[i].getYAxis().setAxisLabelText("y ");

    plots[i].setDim(xSize, ySize);

    if (i < 4)                 { plots[i].setPos(-marginSpace * 4 + 30, interlineSpace * 2 + (i * (ySize + interlineSpace * 2))); }
    else if (i >= 4 && i <= 7) { plots[i].setPos(-marginSpace * 4 + 1030, interlineSpace * 2 + ((i - 4) * (ySize + interlineSpace * 2))); }
    else if ( i == 8 )         { plots[i].setPos(-marginSpace * 4 + 270 , interlineSpace * 2 + (3 * (ySize + interlineSpace * 2))); }
    else if ( i == 9 )         { plots[i].setPos(-marginSpace * 4 + 525 , interlineSpace * 2 + (3 * (ySize + interlineSpace * 2))); }
    else if ( i == 10 )        { plots[i].setPos(-marginSpace * 4 + 785 , interlineSpace * 2 + (3 * (ySize + interlineSpace * 2))); }
     
    // Set the colors

    //plots[i].getYAxis().setAxisLabelText("y axis");
    plots[i].setPointSize(1);
    plots[i].setBoxBgColor(bgColor);
    plots[i].setBgColor(bgColor);
    plots[i].setLabelBgColor(red);
    plots[i].setBoxLineColor(bgColor);
    plots[i].setLineColor(red);
    plots[i].setPointColor(red);
    plots[i].getXAxis().setLineColor(white);
    plots[i].getYAxis().setLineColor(white);
    plots[i].setAllFontProperties("", white, 11);


    for (int j = 0; j < nPoints; j++)
     points[i].add(frameCount, 0);

    plots[i].setPoints(points[i]);
    plots[i].getTitle().setOffset(-interlineSpace);
    plots[i].setFixedYLim(true);
   }

   plots[0].setTitleText("COBE"); //Ecg 
   plots[1].setTitleText("EBF"); //GSr
   plots[2].setTitleText("RMS");
   plots[3].setTitleText("Dynaicity Index");
   plots[4].setTitleText("Spectral Centroid");
   plots[5].setTitleText("Spectral Complexity");
   plots[6].setTitleText("Rhythm Strength");
   plots[7].setTitleText("Rhythm Density");
   plots[8].setTitleText("Skewness D");
   plots[9].setTitleText("Skewness E");
   plots[10].setTitleText("Roughness");


   plots[0].setYLim(0, 1); //cobe
   
   plots[1].setYLim(0, 8000 ); //ebf
   plots[1].getYAxis().setFontSize(7);
   
   plots[2].setYLim(0, 1);
   plots[3].setYLim(0, 1);
   
   plots[4].setYLim(0, 8000);
   plots[4].getYAxis().setFontSize(7);
   
   plots[5].setYLim(0, 50);
   plots[6].setYLim(0, 400);
   plots[7].setYLim(0, 10);
   
   plots[8].setYLim(0, 2000);
   plots[8].getYAxis().setFontSize(7);
   
   plots[9].setYLim(0, 10);
   plots[10].setYLim(0, 1);
   

   for (int j = 0; j < nPoints; j++)
    surfacePoints.add(frameCount, 0);
    
    // Change the second layer options - COBe
   plots[0].addLayer("AvgCOBE", surfacePoints);
   plots[0].getLayer("AvgCOBE").setPoints(surfacePoints);
   plots[0].getLayer("AvgCOBE").setPointSize(1);
   plots[0].getLayer("AvgCOBE").setPointColor(green);
   //plots[0].getLayer("AvgCOBE").setLineColor(green);   
   plots[0].addLayer("TH", surfacePoints);
   plots[0].getLayer("TH").setPoints(surfacePoints);
   plots[0].getLayer("TH").setPointSize(0.6);
   plots[0].getLayer("TH").setPointColor(violet);
   plots[0].addLayer("TH2", surfacePoints);
   plots[0].getLayer("TH2").setPoints(surfacePoints);
   plots[0].getLayer("TH2").setPointSize(0.6);
   plots[0].getLayer("TH2").setPointColor(violet);
   
    // Change the second layer options - EBF
   plots[1].addLayer("AvgEBF", surfacePoints);
   plots[1].getLayer("AvgEBF").setPoints(surfacePoints);
   plots[1].getLayer("AvgEBF").setPointSize(1);
   plots[1].getLayer("AvgEBF").setPointColor(green);
   //plots[1].getLayer("AvgEBF").setLineColor(green);   
   plots[1].addLayer("TH", surfacePoints);
   plots[1].getLayer("TH").setPoints(surfacePoints);
   plots[1].getLayer("TH").setPointSize(0.6);
   plots[1].getLayer("TH").setPointColor(violet);
   plots[1].addLayer("TH2", surfacePoints);
   plots[1].getLayer("TH2").setPoints(surfacePoints);
   plots[1].getLayer("TH2").setPointSize(0.6);
   plots[1].getLayer("TH2").setPointColor(violet);
   
   // Change the second layer options - RMS
   plots[2].addLayer("AvgRMS", surfacePoints);
   plots[2].getLayer("AvgRMS").setPoints(surfacePoints);
   plots[2].getLayer("AvgRMS").setPointSize(1);
   plots[2].getLayer("AvgRMS").setPointColor(green);
   //plots[2].getLayer("AvgRMS").setLineColor(green);   
   plots[2].addLayer("TH", surfacePoints);
   plots[2].getLayer("TH").setPoints(surfacePoints);
   plots[2].getLayer("TH").setPointSize(0.6);
   plots[2].getLayer("TH").setPointColor(violet);
   plots[2].addLayer("TH2", surfacePoints);
   plots[2].getLayer("TH2").setPoints(surfacePoints);
   plots[2].getLayer("TH2").setPointSize(0.6);
   plots[2].getLayer("TH2").setPointColor(violet);

   // Change the second layer options - DynIndex
   plots[3].addLayer("AvgDynIndex", surfacePoints);
   plots[3].getLayer("AvgDynIndex").setPoints(surfacePoints);
   plots[3].getLayer("AvgDynIndex").setPointSize(1);
   plots[3].getLayer("AvgDynIndex").setPointColor(green);
   //plots[3].getLayer("AvgDynIndex").setLineColor(white);
   plots[3].addLayer("TH", surfacePoints);
   plots[3].getLayer("TH").setPoints(surfacePoints);
   plots[3].getLayer("TH").setPointSize(0.6);
   plots[3].getLayer("TH").setPointColor(violet);
   plots[3].addLayer("TH2", surfacePoints);
   plots[3].getLayer("TH2").setPoints(surfacePoints);
   plots[3].getLayer("TH2").setPointSize(0.6);
   plots[3].getLayer("TH2").setPointColor(violet);

   // Change the second layer options - Centroid
   plots[4].addLayer("AvgCentroid", surfacePoints);
   plots[4].getLayer("AvgCentroid").setPoints(surfacePoints);
   plots[4].getLayer("AvgCentroid").setPointSize(1);
   plots[4].getLayer("AvgCentroid").setPointColor(green);
   //plots[4].getLayer("AvgCentroid").setLineColor(white);
   plots[4].addLayer("TH", surfacePoints);
   plots[4].getLayer("TH").setPoints(surfacePoints);
   plots[4].getLayer("TH").setPointSize(0.6);
   plots[4].getLayer("TH").setPointColor(violet);
   plots[4].addLayer("TH2", surfacePoints);
   plots[4].getLayer("TH2").setPoints(surfacePoints);
   plots[4].getLayer("TH2").setPointSize(0.6);
   plots[4].getLayer("TH2").setPointColor(violet);

   plots[5].addLayer("AvgComplexity", surfacePoints);
   plots[5].getLayer("AvgComplexity").setPoints(surfacePoints);
   plots[5].getLayer("AvgComplexity").setPointSize(1);
   plots[5].getLayer("AvgComplexity").setPointColor(green);
   //plots[5].getLayer("AvgComplexity").setLineColor(white);
   plots[5].addLayer("TH", surfacePoints);
   plots[5].getLayer("TH").setPoints(surfacePoints);
   plots[5].getLayer("TH").setPointSize(0.6);
   plots[5].getLayer("TH").setPointColor(violet);
   plots[5].addLayer("TH2", surfacePoints);
   plots[5].getLayer("TH2").setPoints(surfacePoints);
   plots[5].getLayer("TH2").setPointSize(0.6);
   plots[5].getLayer("TH2").setPointColor(violet);

   plots[6].addLayer("AvgRhythmStrength", surfacePoints);
   plots[6].getLayer("AvgRhythmStrength").setPoints(surfacePoints);
   plots[6].getLayer("AvgRhythmStrength").setPointSize(1);
   plots[6].getLayer("AvgRhythmStrength").setPointColor(green);
   //plots[6].getLayer("AvgRhythmStrength").setLineColor(white);
   plots[6].addLayer("TH", surfacePoints);
   plots[6].getLayer("TH").setPoints(surfacePoints);
   plots[6].getLayer("TH").setPointSize(0.6);
   plots[6].getLayer("TH").setPointColor(violet);
   plots[6].addLayer("TH2", surfacePoints);
   plots[6].getLayer("TH2").setPoints(surfacePoints);
   plots[6].getLayer("TH2").setPointSize(0.6);
   plots[6].getLayer("TH2").setPointColor(violet);

   plots[7].addLayer("AvgRhythmDensity", surfacePoints);
   plots[7].getLayer("AvgRhythmDensity").setPoints(surfacePoints);
   plots[7].getLayer("AvgRhythmDensity").setPointSize(1);
   plots[7].getLayer("AvgRhythmDensity").setPointColor(green);
   //plots[7].getLayer("AvgRhythmDensity").setLineColor(white);
   plots[7].addLayer("TH", surfacePoints);
   plots[7].getLayer("TH").setPoints(surfacePoints);
   plots[7].getLayer("TH").setPointSize(0.6);
   plots[7].getLayer("TH").setPointColor(violet);
   plots[7].addLayer("TH2", surfacePoints);
   plots[7].getLayer("TH2").setPoints(surfacePoints);
   plots[7].getLayer("TH2").setPointSize(0.6);
   plots[7].getLayer("TH2").setPointColor(violet);
   
   plots[8].addLayer("AvgSkewnessD", surfacePoints);
   plots[8].getLayer("AvgSkewnessD").setPoints(surfacePoints);
   plots[8].getLayer("AvgSkewnessD").setPointSize(1);
   plots[8].getLayer("AvgSkewnessD").setPointColor(green);
   //plots[8].getLayer("AvgSkewnessD").setLineColor(white);
   plots[8].addLayer("TH", surfacePoints);
   plots[8].getLayer("TH").setPoints(surfacePoints);
   plots[8].getLayer("TH").setPointSize(0.6);
   plots[8].getLayer("TH").setPointColor(violet);
   plots[8].addLayer("TH2", surfacePoints);
   plots[8].getLayer("TH2").setPoints(surfacePoints);
   plots[8].getLayer("TH2").setPointSize(0.6);
   plots[8].getLayer("TH2").setPointColor(violet);
   
   plots[9].addLayer("AvgSkewnessE", surfacePoints);
   plots[9].getLayer("AvgSkewnessE").setPoints(surfacePoints);
   plots[9].getLayer("AvgSkewnessE").setPointSize(1);
   plots[9].getLayer("AvgSkewnessE").setPointColor(green);
   //plots[9].getLayer("AvgSkewnessE").setLineColor(white);
   plots[9].addLayer("TH", surfacePoints);
   plots[9].getLayer("TH").setPoints(surfacePoints);
   plots[9].getLayer("TH").setPointSize(0.6);
   plots[9].getLayer("TH").setPointColor(violet);
   plots[9].addLayer("TH2", surfacePoints);
   plots[9].getLayer("TH2").setPoints(surfacePoints);
   plots[9].getLayer("TH2").setPointSize(0.6);
   plots[9].getLayer("TH2").setPointColor(violet);
   
   plots[10].addLayer("AvgRoughness", surfacePoints);
   plots[10].getLayer("AvgRoughness").setPoints(surfacePoints);
   plots[10].getLayer("AvgRoughness").setPointSize(1);
   plots[10].getLayer("AvgRoughness").setPointColor(green);
   //plots[10].getLayer("AvgRoughness").setLineColor(white);
   plots[10].addLayer("TH", surfacePoints);
   plots[10].getLayer("TH").setPoints(surfacePoints);
   plots[10].getLayer("TH").setPointSize(0.6);
   plots[10].getLayer("TH").setPointColor(violet);
   plots[10].addLayer("TH2", surfacePoints);
   plots[10].getLayer("TH2").setPoints(surfacePoints);
   plots[10].getLayer("TH2").setPointSize(0.6);
   plots[10].getLayer("TH2").setPointColor(violet);

  }

  public void update() 
  {
   addNewPoints();
   removeOldestPoints();
   drawPlots();
  }

  public void addNewPoints() 
  {
   //plots[0].addPoint(frameCount, global_gsr.getNormalized());
   plots[0].addPoint(frameCount, global_timbre.getCOBEsamples());
   plots[0].getLayer("AvgCOBE").addPoint(frameCount, audio_decisor.getFeaturesVector()[6]); //cobe
   plots[0].getLayer("TH").addPoint(frameCount, audio_decisor.getCOBELowerThreshold());
   plots[0].getLayer("TH2").addPoint(frameCount, audio_decisor.getCOBEUpperThreshold());
   
   //plots[1].addPoint(frameCount, global_ecg.getValue());
   plots[1].addPoint(frameCount, global_timbre.getEBFsamples());
   plots[1].getLayer("AvgEBF").addPoint(frameCount, audio_decisor.getFeaturesVector()[7]); //ebf
   plots[1].getLayer("TH").addPoint(frameCount, audio_decisor.getEBFLowerThreshold());
   plots[1].getLayer("TH2").addPoint(frameCount, audio_decisor.getEBFUpperThreshold());

   plots[2].addPoint(frameCount, global_dyn.getRMS());
   plots[2].getLayer("AvgRMS").addPoint(frameCount, audio_decisor.getFeaturesVector()[0]);
   plots[2].getLayer("TH").addPoint(frameCount, audio_decisor.getRMSLowerThreshold());
   plots[2].getLayer("TH2").addPoint(frameCount, audio_decisor.getRMSUpperThreshold());

   plots[3].addPoint(frameCount, global_dyn.getRMSStdDev());
   plots[3].getLayer("AvgDynIndex").addPoint(frameCount, audio_decisor.getFeaturesVector()[1]);
   plots[3].getLayer("TH").addPoint(frameCount, audio_decisor.getDynIndexLowerThreshold());
   plots[3].getLayer("TH2").addPoint(frameCount, audio_decisor.getDynIndexUpperThreshold());

   plots[4].addPoint(frameCount, global_timbre.getCentroidHz());
   plots[4].getLayer("AvgCentroid").addPoint(frameCount, audio_decisor.getFeaturesVector()[2]);
   plots[4].getLayer("TH").addPoint(frameCount, audio_decisor.getCentroidLowerThreshold());
   plots[4].getLayer("TH2").addPoint(frameCount, audio_decisor.getCentroidUpperThreshold());

   plots[5].addPoint(frameCount, global_timbre.getComplexity());
   plots[5].getLayer("AvgComplexity").addPoint(frameCount, audio_decisor.getFeaturesVector()[3]);
   plots[5].getLayer("TH").addPoint(frameCount, audio_decisor.getComplexityLowerThreshold());
   plots[5].getLayer("TH2").addPoint(frameCount, audio_decisor.getComplexityUpperThreshold());

   plots[6].addPoint(frameCount, global_rhythm.getRhythmStrength());
   plots[6].getLayer("AvgRhythmStrength").addPoint(frameCount, audio_decisor.getFeaturesVector()[4]);
   plots[6].getLayer("TH").addPoint(frameCount, audio_decisor.getRhythmStrLowerThreshold());
   plots[6].getLayer("TH2").addPoint(frameCount, audio_decisor.getRhythmStrUpperThreshold());

   plots[7].addPoint(frameCount, global_rhythm.getRhythmDensity());
   plots[7].getLayer("AvgRhythmDensity").addPoint(frameCount, audio_decisor.getFeaturesVector()[5]);
   plots[7].getLayer("TH").addPoint(frameCount, audio_decisor.getRhythmDensLowerThreshold());
   plots[7].getLayer("TH2").addPoint(frameCount, audio_decisor.getRhythmDensUpperThreshold());
   
   plots[8].addPoint(frameCount, global_timbre.getSkewnessD());
   plots[8].getLayer("AvgSkewnessD").addPoint(frameCount, audio_decisor.getFeaturesVector()[8]);
   plots[8].getLayer("TH").addPoint(frameCount, audio_decisor.getSkewnessDLowerThreshold());
   plots[8].getLayer("TH2").addPoint(frameCount, audio_decisor.getSkewnessDUpperThreshold());
   
   plots[9].addPoint(frameCount, global_timbre.getSkewnessE());
   plots[9].getLayer("AvgSkewnessE").addPoint(frameCount, audio_decisor.getFeaturesVector()[9]);
   plots[9].getLayer("TH").addPoint(frameCount, audio_decisor.getSkewnessELowerThreshold());
   plots[9].getLayer("TH2").addPoint(frameCount, audio_decisor.getSkewnessEUpperThreshold());
   
   plots[10].addPoint(frameCount, global_timbre.getRoughness());
   plots[10].getLayer("AvgRoughness").addPoint(frameCount, audio_decisor.getFeaturesVector()[10]);
   plots[10].getLayer("TH").addPoint(frameCount, audio_decisor.getRoughnessLowerThreshold());
   plots[10].getLayer("TH2").addPoint(frameCount, audio_decisor.getRoughnessUpperThreshold());
  }

  public void removeOldestPoints() 
  {
   for (int i = 0; i < plotNumber; i++) 
   {
    plots[i].removePoint(0);
   }
   plots[0].getLayer("AvgCOBE").removePoint(0);
   plots[0].getLayer("TH").removePoint(0);
   plots[0].getLayer("TH2").removePoint(0);
   
   plots[1].getLayer("AvgEBF").removePoint(0);
   plots[1].getLayer("TH").removePoint(0);
   plots[1].getLayer("TH2").removePoint(0);
   
   plots[2].getLayer("AvgRMS").removePoint(0);
   plots[2].getLayer("TH").removePoint(0);
   plots[2].getLayer("TH2").removePoint(0);
   plots[3].getLayer("AvgDynIndex").removePoint(0);
   plots[3].getLayer("TH").removePoint(0);
   plots[3].getLayer("TH2").removePoint(0);
   plots[4].getLayer("AvgCentroid").removePoint(0);
   plots[4].getLayer("TH").removePoint(0);
   plots[4].getLayer("TH2").removePoint(0);
   plots[5].getLayer("AvgComplexity").removePoint(0);
   plots[5].getLayer("TH").removePoint(0);
   plots[5].getLayer("TH2").removePoint(0);
   plots[6].getLayer("AvgRhythmStrength").removePoint(0);
   plots[6].getLayer("TH").removePoint(0);
   plots[6].getLayer("TH2").removePoint(0);
   plots[7].getLayer("AvgRhythmDensity").removePoint(0);
   plots[7].getLayer("TH").removePoint(0);
   plots[7].getLayer("TH2").removePoint(0);
   
   plots[8].getLayer("AvgSkewnessD").removePoint(0);
   plots[8].getLayer("TH").removePoint(0);
   plots[8].getLayer("TH2").removePoint(0);
   plots[9].getLayer("AvgSkewnessE").removePoint(0);
   plots[9].getLayer("TH").removePoint(0);
   plots[9].getLayer("TH2").removePoint(0);  
   plots[10].getLayer("AvgRoughness").removePoint(0);
   plots[10].getLayer("TH").removePoint(0);
   plots[10].getLayer("TH2").removePoint(0);
     
  }

  public void drawPlots() 
  {
   for (int i = 0; i < plotNumber; i++) 
   {
    plots[i].defaultDraw();
   }
   plots[0].getLayer("AvgCOBE").drawPoints();
   plots[0].getLayer("TH").drawPoints();
   plots[0].getLayer("TH2").drawPoints();
   
   plots[1].getLayer("AvgEBF").drawPoints();
   plots[1].getLayer("TH").drawPoints();
   plots[1].getLayer("TH2").drawPoints();
   
   
   plots[2].getLayer("AvgRMS").drawPoints();
   plots[2].getLayer("TH").drawPoints();
   plots[2].getLayer("TH2").drawPoints();
   plots[3].getLayer("AvgDynIndex").drawPoints();
   plots[3].getLayer("TH").drawPoints();
   plots[3].getLayer("TH2").drawPoints();
   plots[4].getLayer("AvgCentroid").drawPoints();
   plots[4].getLayer("TH").drawPoints();
   plots[4].getLayer("TH2").drawPoints();
   plots[5].getLayer("AvgComplexity").drawPoints();
   plots[5].getLayer("TH").drawPoints();
   plots[5].getLayer("TH2").drawPoints();
   plots[6].getLayer("AvgRhythmStrength").drawPoints();
   plots[6].getLayer("TH").drawPoints();
   plots[6].getLayer("TH2").drawPoints();
   plots[7].getLayer("AvgRhythmDensity").drawPoints();
   plots[7].getLayer("TH").drawPoints();
   plots[7].getLayer("TH2").drawPoints();
   
   plots[8].getLayer("AvgSkewnessD").drawPoints();
   plots[8].getLayer("TH").drawPoints();
   plots[8].getLayer("TH2").drawPoints();
   
   plots[9].getLayer("AvgSkewnessE").drawPoints();
   plots[9].getLayer("TH").drawPoints();
   plots[9].getLayer("TH2").drawPoints();
   
   plots[10].getLayer("AvgRoughness").drawPoints();
   plots[10].getLayer("TH").drawPoints();
   plots[10].getLayer("TH2").drawPoints();
  }
 }