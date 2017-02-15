//package dreamo.display;


import processing.serial.*; 
import java.util.Queue;
import java.util.ArrayDeque;

class Connection
{
	//********* CONSTANTS *********** 
	final int MAX_SENSOR = 5; 
	//********* PUBLIC MEMBERS *********** 
	Serial myPort;  // Create object from Serial class
	public PApplet parent; //needed for the Serial object istantiation 
	//********* PRIVATE MEMBERS *********** 
	private boolean wifiAvailable;
	private boolean serialAvailable;
	private boolean connectionAvailable;
	private int executionNumber; // # of times StoreFromText has been called 
	private float incomingValue; // the input coming from a biosensor    
	private final int BUFFER_SIZE = 200; // random value
	private final int lineFeed = 10;    // Linefeed in ASCII    
	private final int numToExtract;
	private String inputString = null;  
	private FloatList incomingCond;
	private FloatList incomingEcg;
	
	private Table conductanceOfflineTable;
	private Table ecgOfflineTable; 
	//********* CONSTRUCTOR *********** 
	public Connection( PApplet p )  // p = parent is needed for the Serial myport ( -->parent<--, list[0], 19200...)
	{
		wifiAvailable = false;
		serialAvailable = false;
		connectionAvailable = false;
		executionNumber = 0;
		incomingValue = 0;
		parent = p;

		incomingCond = new FloatList();
		incomingEcg = new FloatList();
		
		incomingValue = 0;
		parent = p;  //<>//
		// number of BIOMEDICAL VALUES to extract at each update() cycle   
		numToExtract = floor (global_sampleRate/global_fps);  //<>//

		//serial check
		if(!wifiAvailable) 
		{ 
			println("WARNING: Wifi is not available");
			if ( serialConnect() )
				serialAvailable = true;
			else
			{
				println("WARNING: Serial port is not available");
				
				conductanceOfflineTable = loadTable(global_table_con, "header"); // content of log_conductance
				println(conductanceOfflineTable.getRowCount() + " total rows in table conductance");  //<>//
				
				ecgOfflineTable = loadTable(global_table_ecg, "header"); // content of log_conductance
				println(ecgOfflineTable.getRowCount() + " total rows in table ecg"); 
			} 
		}
		
		// IF WIFI OR SERIAL ARE AVAILABLE SET BOOLEAN TO "TRUE"
		if(wifiAvailable || serialAvailable) 
			connectionAvailable = true; 
	}
	
	private boolean wifiConnect()
	{
		boolean wifiAvailable = false;  
		return wifiAvailable;
	}

	public boolean networkAvailable()
	{
		return connectionAvailable;
	}

	private boolean serialConnect() // return TRUE if a serial connection is available
	{
		// I know that the first port in the serial list on my mac
		// is Serial.list()[0].
		// On Windows machines, this generally opens COM1.
		// Open whatever port is the one you're using.
		
		boolean portAvailable = false;
		final String[] ports = Serial.list();
		println( ports );
		
		if (ports.length != 0) // DEBUG = 1 ; RIGHT ONE = 0;
		{
			String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
			myPort = new Serial(parent, portName, 19200);
			portAvailable = true; 
		}
		
		return portAvailable;   
	} 
	
	public void update() //<>//
	{ 
		if( !serialAvailable ) //<>//
			storeFromText();      // read the data from an OFFLINE TABLE
		else if ( serialAvailable )
			storeFromSerial();    // read the data from the SERIAL LINE 
	}
	
	public void storeFromText()
	{ //<>//
		//////////////////////////////////////////////////////////////////////////////////  
		int multiplier = executionNumber; //<>//
		int iStart = 0 + numToExtract*multiplier;
		int iEnd = numToExtract*( multiplier + 1); 
		int count = 0;
		 //<>//
		// INDEX IS SHIFTED TO AVOID READING ALWAYS THE SAME VALUES
		if ( executionNumber >= conductanceOfflineTable.getRowCount()/numToExtract )
			executionNumber = 0;
		//////////////////////////////////////////////////////////////////////////////////
		// CLEAR the list if the list SIZE is five time bigger than needed
		if ( getList("con").size() > numToExtract*5 )
		{ 
			getList("con").clear(); println("List con is now empty"); 
		}
		// add the content of the table to a LIST OF FLOAT
		for (TableRow row : conductanceOfflineTable.rows()) 
		{
			float newFloat = row.getFloat("conductance");
			count++;
			if ( count>=iStart && count<=iEnd ) 
				getList("con").append (newFloat); 
		}          //<>//
		
		if ( getList("con").size() > conductanceOfflineTable.getRowCount() )
		println( "WARNING: class connection, storeFromText(): reading is slower than writing.\n");
		//////////////////////////////////////////////////////////////////////////////////
		count = 0; 
		// CLEAR the list
		if ( getList("ecg").size() > numToExtract*5 )
		{ 
			getList("ecg").clear(); println("List ecg is now empty"); 
		}
		// add the content of the table to a LIST OF FLOAT
	    for (TableRow row : ecgOfflineTable.rows() ) 
		{ 
			float newFloat = row.getFloat("ECG_filtered");
			count++;
			if ( count>=iStart && count<=iEnd ) 
				getList("ecg").append (newFloat); 
		}
		////////////////////////////////////////////////////////////////////////////////// 
		/*println("Offline sensor reading completed. ");
		println("");
		*/
		executionNumber++;
	}

	// the function that reads the DATA from the SERIAL LINE BUFFER
	private void storeFromSerial()
	{
		
		int incomingCondSize = incomingCond.size();
		if ( !serialAvailable ) println(" ERROR: storeFromSerial has been called, but the port is not available");
		if ( incomingCondSize > BUFFER_SIZE ) // security check
		{ 
			incomingCond.clear();
			println("WARNING: list was getting big: list is now empty");
		}
		
		int incomingEcgSize = incomingEcg.size();
		if ( !serialAvailable ) println(" ERROR: storeFromSerial has been called, but the port is not available");
		if ( incomingEcgSize > BUFFER_SIZE ) // security check
		{ 
			incomingEcg.clear();
			println("WARNING: list was getting big: list is now empty");
		}
		
		print( " available bytes on serial buffer: " + myPort.available() );
		
		short added = 0, counter = 0;
		
		myPort.readStringUntil(lineFeed); // clean the garbage

		// while there is something on the serial buffer, add the data to the "incomingCond" queue
		// myPort.available() greater than 4: there's a pending FLOAT on the buffer (size: 4 bytes)
		
		while ( serialAvailable && added < numToExtract && counter < numToExtract*3 && myPort.available() > 4 )
		{
			inputString = myPort.readStringUntil(lineFeed);
			if (inputString != null) 
			{
				incomingValue = float(inputString);  // Converts and prints float
				print( " serial: " + incomingValue );
				
				if(added%2 == 0)
					incomingCond.append(incomingValue);
				else 
					incomingEcg.append(incomingValue);
				
				added++;
				
			}
			
			counter++;
		}
		
		myPort.clear();
		println("");
		println( "DEBUG : incomingCond queue size: " + incomingCond.size() );
		println( "DEBUG : elements added: " + added ); //<>//
		if ( incomingCond.size() == 0 ) println(" ERROR in storeFromSerial: incomingCondSize = 0 ");
		
	}

	// gives out numberOfElements elements from the selected list and ERASE THOSE ELEMENTS
	public FloatList extractFromBuffer (String listName, int numberOfElements) 
	{
		FloatList toOutput = new FloatList();  
		boolean emptyList = false;

		int originalListSize = getList(listName).size();     
		float inValue = 0;
		short added = 0; 

		if (listName.equals("con") || listName.equals("ecg")) //<>//
		{
			// extract numberOfElements of elements from conductance list 
			while(! (getList(listName).size() <= originalListSize  - numberOfElements) && !emptyList) 
			{
				int currentListSize = getList(listName).size();
				if ( currentListSize > 0 )
				{        
					int index = currentListSize - 1;
					if ( index >= 0 && index <= currentListSize )
					{
						if(listName.equals("con")) 
							inValue = incomingCond.remove( index );
						else
							inValue = incomingEcg.remove( index );
						if ( inValue >= 0 && inValue <= MAX_SENSOR )
						{
							toOutput.append( inValue );
							added++;
						}                         
					}             
				}
				else
					emptyList = true; 
			}                
		}
		return toOutput;
	}

	public FloatList getList(String sensorName)
	{
		if( sensorName.equals("con") )
			return incomingCond;
		else if( sensorName.equals("ecg") )
			return	incomingEcg;
		else
			return null;
	}
}