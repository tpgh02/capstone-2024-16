import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.0/firebase-app.js";
import { getFirestore, collection, doc, setDoc, getDoc, query, where, getDocs } from "https://www.gstatic.com/firebasejs/10.12.0/firebase-firestore.js";
const firebaseConfig = {
    apiKey: "AIzaSyDIKEbWbLmeBTzo_N8EJnaoRIr-X_jUoXw",
    authDomain: "yuyuyuhak-9977f.firebaseapp.com",
    projectId: "yuyuyuhak-9977f",
    storageBucket: "yuyuyuhak-9977f.appspot.com",
    messagingSenderId: "886102812300",
    appId: "1:886102812300:web:f586a4b9196fc8259dfda9",
    measurementId: "G-464Y3D0G1F"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// 지역으로 구분
const usaq = query(collection(db, "eng_region"), where("region", "==", "usa"));
let usaArray = [];
const canq = query(collection(db, "eng_region"), where("region", "==", "canada"));
let canArray = [];
const oceq = query(collection(db, "eng_region"), where("region", "==", "oceania"));
let oceArray = [];

const usaSnapshot = await getDocs(usaq);
usaSnapshot.forEach((doc) => {
  usaArray.push([doc.data().info, doc.data().org_name, doc.data().org_type, doc.data().region]);
});

const canSnapshot = await getDocs(canq);
canSnapshot.forEach((doc) => {
  canArray.push([doc.data().info, doc.data().org_name, doc.data().org_type, doc.data().region]);
});

const oceSnapshot = await getDocs(oceq);
oceSnapshot.forEach((doc) => {
  oceArray.push([doc.data().info, doc.data().org_name, doc.data().org_type, doc.data().region]);
});

// 기관 종류로 구분
const univq = query(collection(db, "eng_region"), where("org_type", "==", "univ"));
let univArray = [];
const colq = query(collection(db, "eng_region"), where("org_type", "==", "college"));
let colArray = [];
const etcq = query(collection(db, "eng_region"), where("org_type", "==", "etc"));
let etcArray = [];

const univSnapshot = await getDocs(univq);
univSnapshot.forEach((doc) => {
  univArray.push([doc.data().info, doc.data().org_name, doc.data().org_type, doc.data().region]);
});

const colSnapshot = await getDocs(colq);
colSnapshot.forEach((doc) => {
  colArray.push([doc.data().info, doc.data().org_name, doc.data().org_type, doc.data().region]);
});

const etcSnapshot = await getDocs(etcq);
etcSnapshot.forEach((doc) => {
  etcArray.push([doc.data().info, doc.data().org_name, doc.data().org_type, doc.data().region]);
});


export {usaArray, canArray, oceArray}
export {univArray, colArray, etcArray}