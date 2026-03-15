// Fetch data from server and update dashboard
const API_URL = 'http://localhost:3000/api/powerplant';
const STATUS_URL = 'http://localhost:3000/api/status';

let updateInterval;

async function fetchData() {
    try {
        const response = await fetch(API_URL);
        if (!response.ok) throw new Error('Failed to fetch data');
        
        const data = await response.json();
        updateDashboard(data);
        updateConnectionStatus(true);
    } catch (error) {
        console.error('Error fetching data:', error);
        updateConnectionStatus(false);
    }
}

async function checkStatus() {
    try {
        const response = await fetch(STATUS_URL);
        if (!response.ok) throw new Error('Failed to fetch status');
        
        const status = await response.json();
        const statusElement = document.getElementById('connection-status');
        
        if (status.connected) {
            statusElement.textContent = '✓ Connected';
            statusElement.style.color = '#00ff41';
        } else {
            statusElement.textContent = '✗ Disconnected';
            statusElement.style.color = '#ff6b6b';
        }
    } catch (error) {
        console.error('Error checking status:', error);
        document.getElementById('connection-status').textContent = '✗ Error';
        document.getElementById('connection-status').style.color = '#ff6b6b';
    }
}

function updateDashboard(data) {
    // Power Info
    document.getElementById('production').textContent = (data.production || 0).toFixed(0);
    document.getElementById('consumption').textContent = (data.consumption || 0).toFixed(0);
    document.getElementById('capacity').textContent = (data.capacity || 0).toFixed(0);
    
    // Left (capacity - consumption) with color coding
    const leftValue = data.left || 0;
    const leftElement = document.getElementById('left');
    leftElement.textContent = leftValue.toFixed(0);
    
    const leftItemElement = leftElement.closest('.power-item');
    leftItemElement.className = 'power-item';
    if (leftValue < 100) {
        leftItemElement.style.borderColor = '#ff6b6b';
        leftItemElement.style.background = 'rgba(255, 107, 107, 0.05)';
        leftElement.style.color = '#ff6b6b';
    } else if (leftValue < 500) {
        leftItemElement.style.borderColor = '#ffaa00';
        leftItemElement.style.background = 'rgba(255, 170, 0, 0.05)';
        leftElement.style.color = '#ffaa00';
    } else {
        leftItemElement.style.borderColor = '#00ff41';
        leftItemElement.style.background = 'rgba(0, 255, 65, 0.05)';
        leftElement.style.color = '#00ff41';
    }
    
    // Battery
    const batteryPercent = data.batteryCapacity ? Math.round((data.batteryStore / data.batteryCapacity) * 100) : 0;
    document.getElementById('battery-percent').textContent = batteryPercent + '%';
    document.getElementById('battery-bar').style.width = batteryPercent + '%';
    document.getElementById('battery-val').textContent = `${(data.batteryStore || 0).toFixed(0)}MW / ${(data.batteryCapacity || 0).toFixed(0)}MW`;
    
    // Time
    if (data.localTime) {
        document.getElementById('local-time').textContent = data.localTime;
    }
    if (data.daysSinceLanding !== undefined) {
        document.getElementById('days-since-landing').textContent = data.daysSinceLanding;
    }
    
    // Reactors
    if (data.reactors) {
        data.reactors.forEach((reactor, index) => {
            const card = document.getElementById(`reactor-${reactor.id}`);
            if (card) {
                const statusText = reactor.standby ? 'STANDBY' : 'ACTIVE';
                const statusClass = reactor.standby ? 'standby' : 'active';
                card.className = `reactor-card ${statusClass}`;
                
                const efficiencyPercent = reactor.efficiency || 0;
                card.innerHTML = `
                    <div class="reactor-status">${statusText}</div>
                    <div class="reactor-efficiency">${efficiencyPercent}%</div>
                    <div class="reactor-label">Reactor ${reactor.id}</div>
                `;
            }
        });
    }
    
    // Storage
    updateStorageBar('fuel-rod', data.fuelRodStorage, 'items');
    updateStorageBar('water-tank', data.waterTank, 'amount');
    updateStorageBar('nuclear-waste', data.nuclearWaste, 'items');
    updateStorageBar('fabric-storage', data.fabricStorage, 'items');
}

function updateStorageBar(elementId, storageData, type) {
    if (!storageData) return;
    
    const container = document.getElementById(elementId);
    if (!container) return;
    
    const percent = Math.round(storageData.fillPercent || 0);
    const bar = container.querySelector('.storage-bar');
    const fill = container.querySelector('.fill');
    const percent_text = container.querySelector('.percent');
    const count_text = container.querySelector('.count');
    
    if (fill) fill.style.width = percent + '%';
    if (percent_text) percent_text.textContent = percent + '%';
    
    if (type === 'items' && storageData.itemCount !== undefined) {
        if (count_text) count_text.textContent = 'Items: ' + storageData.itemCount;
    } else if (type === 'amount' && storageData.amount !== undefined) {
        if (count_text) count_text.textContent = (storageData.amount || 0).toFixed(1) + 'L';
    }
}

function updateConnectionStatus(connected) {
    const statusElement = document.getElementById('connection-status');
    if (connected) {
        statusElement.textContent = '✓ Connected';
        statusElement.style.color = '#00ff41';
    } else {
        statusElement.textContent = '✗ Disconnected';
        statusElement.style.color = '#ff6b6b';
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    console.log('Dashboard initialized');
    
    // Fetch immediately
    fetchData();
    checkStatus();
    
    // Then poll every 2 seconds
    updateInterval = setInterval(() => {
        fetchData();
        checkStatus();
    }, 2000);
});

// Cleanup on page unload
window.addEventListener('unload', () => {
    if (updateInterval) clearInterval(updateInterval);
});
