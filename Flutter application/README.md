-This project is a flutter based mobile application system for a movie recommendation system.

- The recommendations are provided to the app through a flask based recommendation model through an API and functions on the algorithm for content-based filtering, specifically cosine similarity method to compare how similar two movies are based on the keywords and cast involved.
- App can be created by setting new account or by using a demo account that I have created i.e email:abc@gmail.com, password:123456

- The dataset used in the app is fetched from TMDB(https://www.themoviedb.org/).
- Data such as photos, ratings, cast involved are also provided by TMDB.



- Various flutter packages used in the application are:
  cupertino_icons: ^1.0.2
  card_swiper : ^1.0.4
  http: ^0.13.3
  provider: ^6.0.1
  font_awesome_flutter: ^10.1.0
  google_fonts: ^3.0.1
  shared_preferences: ^2.0.15
  firebase_core: ^1.17.0
  firebase_auth: ^3.3.18
  cloud_firestore: ^3.1.16
  modal_progress_hud_nsn: ^0.1.0-nullsafety-1
  google_sign_in: ^5.3.2
  fluttertoast: ^8.0.8


- Firebase is used to set up user authentication.
- SharedPreferences is used to store the recommendations of a user on local storage to improve the code performance.