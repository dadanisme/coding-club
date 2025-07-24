// Navigation functionality
document.addEventListener('DOMContentLoaded', function() {
    const navBtns = document.querySelectorAll('.nav-btn');
    const sections = document.querySelectorAll('.section');
    
    navBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const targetSection = this.dataset.section;
            
            // Remove active class from all nav buttons and sections
            navBtns.forEach(b => b.classList.remove('active'));
            sections.forEach(s => s.classList.remove('active'));
            
            // Add active class to clicked button and corresponding section
            this.classList.add('active');
            document.getElementById(targetSection).classList.add('active');
        });
    });
    
    // Handle create form submission
    const createForm = document.getElementById('create-form');
    if (createForm) {
        createForm.addEventListener('submit', createLightsaber);
    }
    
    // Handle get all lightsabers button
    const getAllBtn = document.getElementById('get-all-btn');
    if (getAllBtn) {
        getAllBtn.addEventListener('click', getAllLightsabers);
    }
});

// API Testing Functions
const BASE_URL = '/api';

async function makeAPIRequest(method, endpoint, body = null) {
    const url = `${BASE_URL}${endpoint}`;
    console.log(`Making ${method} request to: ${url}`);
    
    const options = {
        method: method,
        headers: {
            'Content-Type': 'application/json',
        }
    };
    
    if (body) {
        options.body = JSON.stringify(body);
        console.log('Request body:', body);
    }
    
    try {
        const response = await fetch(url, options);
        console.log('Response status:', response.status);
        
        let data;
        try {
            data = await response.json();
        } catch (parseError) {
            console.error('Failed to parse response as JSON:', parseError);
            data = { error: 'Invalid JSON response' };
        }
        
        displayResponse({
            status: response.status,
            statusText: response.statusText,
            data: data,
            url: url,
            method: method
        });
        
        return data;
    } catch (error) {
        console.error('Network error:', error);
        displayResponse({
            status: 'Error',
            statusText: 'Network Error',
            data: { error: error.message },
            url: url,
            method: method
        });
        throw error;
    }
}

function displayResponse(response) {
    const container = document.getElementById('response-container');
    const timestamp = new Date().toLocaleTimeString();
    
    const statusClass = response.status >= 200 && response.status < 300 ? 'response-success' : 'response-error';
    
    container.innerHTML = `
        <div class="response-header">
            <strong>${response.method} ${response.url}</strong>
            <span style="float: right; color: var(--text-secondary);">${timestamp}</span>
        </div>
        <div class="response-status ${statusClass}">
            Status: ${response.status} ${response.statusText}
        </div>
        <div class="response-body">
            <h4 style="color: var(--accent-blue); margin: 1rem 0 0.5rem 0;">Response Body:</h4>
            <pre><code>${JSON.stringify(response.data, null, 2)}</code></pre>
        </div>
    `;
}

async function getAllLightsabers() {
    console.log('getAllLightsabers called');
    
    const colorElement = document.getElementById('filter-color');
    const creatorElement = document.getElementById('filter-creator');
    
    if (!colorElement || !creatorElement) {
        console.error('Form elements not found');
        return;
    }
    
    const color = colorElement.value;
    const creator = creatorElement.value.trim();
    
    let endpoint = '/lightsabers';
    const params = new URLSearchParams();
    
    if (color) params.append('color', color);
    if (creator) params.append('creator', creator);
    
    if (params.toString()) {
        endpoint += '?' + params.toString();
    }
    
    console.log('Making request to:', endpoint);
    await makeAPIRequest('GET', endpoint);
}

async function createLightsaber(event) {
    event.preventDefault();
    
    const formData = {
        name: document.getElementById('create-name').value.trim(),
        color: document.getElementById('create-color').value,
        creator: document.getElementById('create-creator').value.trim(),
        crystalType: document.getElementById('create-crystal').value,
        hiltMaterial: document.getElementById('create-material').value,
        isActive: document.getElementById('create-active').value === 'true'
    };
    
    // Validate required fields
    const requiredFields = ['name', 'color', 'creator', 'crystalType', 'hiltMaterial'];
    const missingFields = requiredFields.filter(field => !formData[field]);
    
    if (missingFields.length > 0) {
        alert(`Please fill in all required fields: ${missingFields.join(', ')}`);
        return;
    }
    
    try {
        await makeAPIRequest('POST', '/lightsabers', formData);
        
        // Reset form on success
        document.getElementById('create-form').reset();
    } catch (error) {
        console.error('Error creating lightsaber:', error);
    }
}

// Helper function to get a lightsaber by ID (for testing)
async function getLightsaberById(id) {
    if (!id) {
        const userInput = prompt('Enter lightsaber ID:');
        if (!userInput) return;
        id = userInput;
    }
    
    await makeAPIRequest('GET', `/lightsabers/${id}`);
}

// Helper function to update a lightsaber (for testing)
async function updateLightsaber(id, updates) {
    if (!id) {
        const userInput = prompt('Enter lightsaber ID:');
        if (!userInput) return;
        id = userInput;
    }
    
    if (!updates) {
        // Example update for testing
        updates = {
            color: 'red',
            isActive: false
        };
    }
    
    await makeAPIRequest('PATCH', `/lightsabers/${id}`, updates);
}

// Helper function to delete a lightsaber (for testing)
async function deleteLightsaber(id) {
    if (!id) {
        const userInput = prompt('Enter lightsaber ID to delete:');
        if (!userInput) return;
        id = userInput;
    }
    
    if (!confirm(`Are you sure you want to delete lightsaber ${id}?`)) {
        return;
    }
    
    await makeAPIRequest('DELETE', `/lightsabers/${id}`);
}

// Add some example functions to the global scope for console testing
window.testAPI = {
    getAllLightsabers,
    getLightsaberById,
    updateLightsaber,
    deleteLightsaber,
    createLightsaber: (data) => makeAPIRequest('POST', '/lightsabers', data)
};

// Add some sample data for quick testing
window.sampleLightsaber = {
    name: "Obi-Wan's Lightsaber",
    color: "blue",
    creator: "Obi-Wan Kenobi",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    isActive: true
};