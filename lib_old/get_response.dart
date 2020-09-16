import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Organization {
  var firebaseUser;
  var firebaseOrganizationRef;
  var firebaseSpecificOrganizationRef;
  var organizationName;
  var firebaseRootRef;
  SharedPreferences sharedPreferences;

  Organization(){
    // initRef();
  }

  Future<void> initRef() async {
    sharedPreferences = await SharedPreferences.getInstance();
    firebaseUser = await FirebaseAuth.instance.currentUser();
    firebaseRootRef = FirebaseDatabase.instance.reference();
    firebaseOrganizationRef = firebaseRootRef
            .child('users')
            .child(firebaseUser.uid)
            .child('personal_details')
            .child('organization');
    DataSnapshot dataSnapshot = await firebaseOrganizationRef.once();
    organizationName = dataSnapshot.value();
    firebaseSpecificOrganizationRef = firebaseRootRef.child('organization').child(organizationName);
  }

  Future<int> getCount() async {
    await initRef();
    DataSnapshot dataSnapshot = await firebaseSpecificOrganizationRef.once();
    print(dataSnapshot.value.toString());
    print("Length = " + dataSnapshot.value.length);
    return dataSnapshot.value.length;
  }

  saveCountToSharedPreferences() async {
    var organizationCount = await getCount();
    sharedPreferences.setInt("organization_count", organizationCount);
  }

}


