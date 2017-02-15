class Ecg extends Biosensor
{
	public void init()
	{
		sensorName = "ecg";   
	}
	
	public void update()
	{          
		float currentValue = getAbsolute();
		int numToExtract = ceil (global_sampleRate/frameRate); //<>//
		long initTimeT = System.nanoTime();     
		
		incomingValues = global_connection.extractFromBuffer("ecg", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst 
		currentValue = computeAverage(incomingValues, getDefault() );
		 
		setValue( currentValue );
		
		if (incomingValues != null)
			checkCalibration();
	} 
}