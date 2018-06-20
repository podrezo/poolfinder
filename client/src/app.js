import './assets/scss/app.scss';
// import firebase from 'firebase';

window.onload = () => {
  console.log('document loaded!');
  var config = {
    apiKey: "AIzaSyDJMLTmpU6Z-Pu8eXG6iK2c8APkoH_NIlA",
    authDomain: "poolfinder-2679b.firebaseapp.com",
    databaseURL: "https://poolfinder-2679b.firebaseio.com",
    projectId: "poolfinder-2679b",
    storageBucket: "poolfinder-2679b.appspot.com",
    messagingSenderId: "1093689089159"
  };
  firebase.initializeApp(config);
  const firestore = firebase.firestore();
  const settings = { /* your settings... */ timestampsInSnapshots: true };
  firestore.settings(settings);

  var db = firebase.firestore();

  db
    .collection("locations")
    .where("name", "==", "Swansea Community Recreation Centre")
    .get()
    .then(querySnapshot => {
      querySnapshot.forEach(doc => {
        console.log(`${doc.id} => ${JSON.stringify(doc.data())}`);
      });
    });
};




