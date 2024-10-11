//firebase
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/10.14.0/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.14.0/firebase-analytics.js";
  import { getDatabase, ref, onValue } from "https://www.gstatic.com/firebasejs/10.14.0/firebase-database.js"; 
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const firebaseConfig = {
    apiKey: "AIzaSyDcbKrtadBgrisac9sF5IX0VigxopOOqEc",
    authDomain: "sensors-9d5a8.firebaseapp.com",
    databaseURL: "https://sensors-9d5a8-default-rtdb.firebaseio.com",
    projectId: "sensors-9d5a8",
    storageBucket: "sensors-9d5a8.appspot.com",
    messagingSenderId: "107486041056",
    appId: "1:107486041056:web:b0247fae0c62fe17ded185",
    measurementId: "G-JKCMQGSJJL"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);



//Initialize bd
const db = getDatabase(app); // Para Realtime Database
/*const dbFirestore = getFirestore(app); // Para Firestore*/
const dataRef = ref(db, '/') // aqui va la clave api web ?? AIzaSyDcbKrtadBgrisac9sF5IX0VigxopOOqEc

//cambios en la bd
onValue(dataRef, (snapshot) => {
    const data = snapshot.val();
    updateCharts(data);
});
/*
// Write
await setDoc(doc(db, "users", "alovelace"), {
  firstname: "Ada",
  lastname: "Lovelace",
});
// Read / listen / se necesita algo asi?
onSnapshot(doc(db, "users", "alovelace"), (docSnapshot) => {
  console.log("Latest data: ", docSnapshot.data());
  // ...
});
*/

// desplegar/cerrar menu
const menuIcon = document.querySelector('.bx-menu');
const sidebar = document.querySelector('#sidebar');
menuIcon.addEventListener('click', function() {
    sidebar.classList.toggle('hide');
});


function updateCharts(data) {

    const labels = [];
    const humidityData = [];
    const temperatureData = [];
    const groundHumidityData = [];

    // iterar sobre los datos para extraer las fechas, humedad y temperatura

    // temperature-humidity
    for (const date in data['temperature-humidity']) {
        if (data['temperature-humidity'].hasOwnProperty(date)) {
            
            labels.push(date); // clave del objeto como fecha

            const entry = data['temperature-humidity'][date];
            for (const time in entry) {
                if (entry.hasOwnProperty(time)) {
                    humidityData.push(entry[time].humidity.value); 
                    temperatureData.push(entry[time].temperature.value); 
                    break; //para tener el primer registro
                }
            }
        }
    }

    // ground_humidity
    for (const date in data.ground_humidity) {
        if (data.ground_humidity.hasOwnProperty(date)) {
            const entry = data.ground_humidity[date];
            for (const time in entry) {
                if (entry.hasOwnProperty(time)) {
                    groundHumidityData.push(entry[time].value); 
                    break; 
                }
            }
        }
    }



    //graficas
    const ctx = document.getElementById('lineChart').getContext('2d'); 
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Humedad Ambiental', 
                data: humidityData,
                fill: false,
                borderColor: '#188779',
                tension: 0.1,
                borderWidth: 2 
            },
            {
                label: 'Temperatura Ambiental', 
                data: temperatureData, 
                fill: false,
                borderColor: '#2FC2B0', 
                tension: 0.1,
                borderWidth: 2 
            }]
        },
        
        options: {
            responsive: true,
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Octubre'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Parametros'
                    },
                    beginAtZero: true 
                }
            }
        }
    });
    const barCtx = document.getElementById('barChart').getContext('2d');
    new Chart(barCtx, {
        type: 'bar', 
        data: {
            labels: labels, 
            datasets: [{
                label: 'Humedad del Suelo', 
                data: groundHumidityData,
                backgroundColor: 'rgba(47, 194, 176, 0.6)', 
                borderColor: '#30BCAB', 
                borderWidth: 1.2
            }]
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Octubre'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Humedad'
                    },
                    beginAtZero: true
                }
            }
        }
    });
}