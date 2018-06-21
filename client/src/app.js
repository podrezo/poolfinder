import './assets/scss/app.scss';
import firebase from './firebase';

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
