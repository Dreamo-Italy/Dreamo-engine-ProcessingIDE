class Gsr extends Biosensor
{
	public void init()
	{
		sensorName = "con";   
	}
	
	public void update()
	{          
		float currentValue = getAbsolute();
		int numToExtract = ceil (global_sampleRate/frameRate); //<>//
		long initTimeT = System.nanoTime();     

		incomingValues = global_connection.extractFromBuffer("con", numToExtract ); // store the incoming conductance  
		
		currentValue = computeAverage(incomingValues, getDefault() );
		
		setValue  ( currentValue );
		
		if (incomingValues != null)
			checkCalibration();
	}

}