import 'script-loader!firebase/firebase-app';
import 'script-loader!firebase/firebase-firestore';

// These are public facing keys required by Firebase to be available to the
// clients. It is not a security risk.
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

var getLocations = () => {
  return new Promise((resolve, reject) => {
    db
      .collection("locations")
      // .where("name", "==", "Swansea Community Recreation Centre")
      .get()
      .then(querySnapshot => {
        var results = [];
        querySnapshot.forEach(doc => {
          results.push(doc.data());
        });
        resolve(results);
      })
      .catch(err => reject(err));
  });
};

var getSchedule = (timeMin, timeMax) => {
  return new Promise((resolve, reject) => {
    // TODO: This is not optimal because we're getting all swim times, even for places not near us
    db
      .collection("schedule")
      .where("from", ">", timeMin)
      .where("from", "<", timeMax)
      .get()
      .then(querySnapshot => {
        var results = [];
        querySnapshot.forEach(doc => {
          results.push(doc.data());
        });
        resolve(results);
      })
      .catch(err => reject(err));
  });
}

export {getLocations, getSchedule};