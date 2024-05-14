import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.0/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.12.0/firebase-analytics.js";
const firebaseConfig = {
    apiKey: "AIzaSyDIKEbWbLmeBTzo_N8EJnaoRIr-X_jUoXw",
    authDomain: "yuyuyuhak-9977f.firebaseapp.com",
    projectId: "yuyuyuhak-9977f",
    storageBucket: "yuyuyuhak-9977f.appspot.com",
    messagingSenderId: "886102812300",
    appId: "1:886102812300:web:f586a4b9196fc8259dfda9",
    measurementId: "G-464Y3D0G1F"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

import { getAuth, signInWithEmailAndPassword, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/10.12.0/firebase-auth.js";
const uid = '';

// 페이지 이동 링크
var link = '../mainscreen_login.html';

document.getElementById('login').addEventListener('click', (event) => {
    event.preventDefault();
    const usermail = document.getElementById('loginmail').value;
    const userpwd = document.getElementById('loginpwd').value;
    const auth = getAuth();

    signInWithEmailAndPassword(auth, usermail, userpwd)
    .then((result) => {
        
        location.href = link;
        location.replace(link);
        window.open(link);
    }).catch((error) => {
        console.log(error)
        alert('아이디 또는 비밀번호가 틀립니다.');
    })
})