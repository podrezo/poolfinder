import './assets/scss/app.scss';
import firebase from './js/firebase';
import './js/react-root';
import './js/sidemenu';

import 'script-loader!moment/moment';

var db = firebase.firestore();

// db
//   .collection("locations")
//   .where("name", "==", "Swansea Community Recreation Centre")
//   .get()
//   .then(querySnapshot => {
//     querySnapshot.forEach(doc => {
//       console.log(`${doc.id} => ${JSON.stringify(doc.data())}`);
//     });
//   });

var now = new Date();
var later = new Date(Date.now() + 1000*60*60*5);

db
  .collection("schedule")
  .where("from", ">", now)
  .where("from", "<", later)
  .limit(20)
  .get()
  .then(querySnapshot => {
    querySnapshot.forEach(doc => {
      var d = doc.data();
      var from = moment(d.from.seconds*1000).calendar(); 
      var to = moment(d.to.seconds*1000).format('LT');
      console.log(`${d.activity_name} @ ${d.location_name}, ${from} --> ${to}`);
    });
  });
