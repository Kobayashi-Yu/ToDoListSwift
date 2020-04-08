# Firebaseのセキュリティルール

------------------------------------------------------------------------------------
{
  /* Visit https://firebase.google.com/docs/database/security to learn more about security rules. */
  "rules": {
  	"users":{
      "$uid":{
        ".read":"auth != null && auth.uid == $uid",
        ".write":"auth != null && auth.uid == $uid",
        "items":{
          "$item_id":{
            "title":{
              ".validate":"newData.isString() && newData.val().length > 0"
            }
          }
        }
      }
    }
  }
}

------------------------------------------------------------------------------------
