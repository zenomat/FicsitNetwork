const express = require('express');
const path = require('path');
const fs = require('fs');
const os = require('os');
const app = express();
const PORT = 3000;

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json({ limit: '10mb' }));

let powerPlantData = {
  production: 0,
  consumption: 0,
  capacity: 0,
  left: 0,
  batteryStore: 0,
  batteryCapacity: 0,
  daysSinceLanding: 0,
  localTime: "00:00:00",
  reactors: [
    { id: 1, standby: false, efficiency: 0 },
    { id: 2, standby: false, efficiency: 0 },
    { id: 3, standby: true, efficiency: 0 },
    { id: 4, standby: false, efficiency: 0 }
  ],
  fuelRodStorage: { fillPercent: 0, itemCount: 0 },
  waterTank: { fillPercent: 0, amount: 0 },
  nuclearWaste: { fillPercent: 0, itemCount: 0 },
  fabricStorage: { fillPercent: 0, itemCount: 0 }
};

let lastDataUpdate = new Date();

// Look for the data file in Satisfactory SaveGames folder
let dataFilePath = null;

function findDataFile() {
  // Try typical Satisfactory SaveGames locations
  const userProfile = process.env.USERPROFILE || os.homedir();
  
  const possiblePaths = [
    // The correct path from user
    'c:\\Users\\zmate\\AppData\\Local\\FactoryGame\\Saved\\SaveGames\\Computers\\F3EF3D7648534B534ECB9E84464ECF0E\\powerplant_data.json',
    // Default Satisfactory SaveGames location (look for any computer folder)
    path.join(userProfile, 'AppData', 'Local', 'FactoryGame', 'Saved', 'SaveGames', 'Computers'),
    // Also try the workspace location as fallback
    path.join(__dirname, '..', 'UraniumPowerPlant', 'powerplant_data.json'),
    // Try root of workspace
    path.join(__dirname, '..', 'powerplant_data.json')
  ];
  
  console.log('Looking for powerplant_data.json...');
  
  // First check the exact path provided
  if (fs.existsSync(possiblePaths[0])) {
    console.log(`✓ FOUND at: ${possiblePaths[0]}`);
    return possiblePaths[0];
  }
  
  // Then try to find in the Computers folder
  const computersFolderPath = possiblePaths[1];
  if (fs.existsSync(computersFolderPath)) {
    console.log(`  Searching in: ${computersFolderPath}`);
    try {
      const computers = fs.readdirSync(computersFolderPath);
      for (const computerId of computers) {
        const filePath = path.join(computersFolderPath, computerId, 'powerplant_data.json');
        if (fs.existsSync(filePath)) {
          console.log(`  ✓ FOUND at: ${filePath}`);
          return filePath;
        }
      }
    } catch (e) {
      // Ignore errors
    }
  }
  
  // Try other paths
  for (let i = 2; i < possiblePaths.length; i++) {
    const filePath = possiblePaths[i];
    if (fs.existsSync(filePath)) {
      console.log(`  ✓ FOUND at: ${filePath}`);
      return filePath;
    }
  }
  
  console.log('  (file not found yet - waiting for Lua to write it)');
  return null;
}

// Find the data file on startup
dataFilePath = findDataFile();

// Check for data file every 250ms
function checkDataFile() {
  // If we haven't found the file yet, keep looking
  if (!dataFilePath) {
    dataFilePath = findDataFile();
    if (!dataFilePath) return; // Still not found
  }
  
  try {
    if (fs.existsSync(dataFilePath)) {
      const stat = fs.statSync(dataFilePath);
      const fileModTime = stat.mtime;
      
      // Only read if file was recently modified
      if (fileModTime > lastDataUpdate) {
        const fileData = fs.readFileSync(dataFilePath, 'utf8');
        if (fileData) {
          const parsedData = JSON.parse(fileData);
          powerPlantData = { ...powerPlantData, ...parsedData };
          lastDataUpdate = new Date();
          console.log(`[${new Date().toLocaleTimeString()}] Data updated - Production: ${parsedData.production}MW, Consumption: ${parsedData.consumption}MW`);
        }
      }
    }
  } catch (error) {
    console.error(`Error reading data file: ${error.message}`);
  }
}

// Poll the file every 250ms
setInterval(checkDataFile, 250);

// API endpoint to get power plant data
app.get('/api/powerplant', (req, res) => {
  res.json(powerPlantData);
});

// API endpoint to check connection status
app.get('/api/status', (req, res) => {
  const timeSinceUpdate = (Date.now() - lastDataUpdate) / 1000;
  const isConnected = timeSinceUpdate < 5;
  
  res.json({
    connected: isConnected,
    lastUpdate: lastDataUpdate.toISOString(),
    secondsSinceUpdate: Math.floor(timeSinceUpdate),
    dataFilePath: dataFilePath || 'not found'
  });
});

// Reactor control endpoint
app.post('/api/reactor/:id/standby', (req, res) => {
  const id = parseInt(req.params.id) - 1;
  if (powerPlantData.reactors[id]) {
    powerPlantData.reactors[id].standby = req.body.standby;
    res.json({ success: true, reactor: powerPlantData.reactors[id] });
  } else {
    res.status(404).json({ success: false, error: 'Reactor not found' });
  }
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n${'='.repeat(60)}`);
  console.log(`⚛️  Uranium Power Plant Dashboard`);
  console.log(`${'='.repeat(60)}`);
  console.log(`Server running at: http://localhost:${PORT}`);
  console.log(`${'='.repeat(60)}`);
  console.log('Waiting for data from Lua game...');
  console.log('Press Ctrl+C to stop\n');
  
  // Do initial check
  checkDataFile();
}).on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`\n❌ Port ${PORT} is already in use!`);
    console.error('Try: taskkill /F /IM node.exe');
    process.exit(1);
  }
  throw err;
});
