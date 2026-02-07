// Configuration for the frontend application
// This file will be dynamically generated with environment variables

window.apiConfig = {
    // Backend API base URL
    // Default to localhost for local development
    apiBaseUrl: 'http://localhost:8080',
    
    // Endpoints
    endpoints: {
        saludo: '/saludo',
        mostrarSecreto: '/mostrar_secreto'
    }
};
