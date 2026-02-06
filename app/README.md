# DevBlog Mobile App 🚀

Mashruucan waa Flutter App loogu talagalay akhriska iyo qoraalka baloogyada teknoolajiyada, isagoo ku xiran Backend laga sameeyay Node.js.

## 🏗️ App Architecture (Qaab-dhismeedka Mashruuca)

Waxaan mashruucan u dhisnay qaab mihnadeed oo u dhow **MVVM (Model-View-ViewModel)**, kaas oo u qaybsan lakabyo kala duwan si koodhku u noqodo mid nadiif ah oo fudud in la beddelo.

### Lakabyada Mashruuca (Project Layers):
1.  **Models (`lib/models/`)**: Waxay mas'uul ka yihiin qeexidda qaabka xogta (User iyo Post).
2.  **Services (`lib/services/`)**: Halkan waxaa ku jira `ApiService` oo ah lakabka kaliya ee xiriirka la leh Backend-ka (Node.js API).
3.  **Providers (`lib/providers/`)**: Waa halka laga maamulo **State Management**. Waxaan isticmaalnay `Provider` si aan ula wadaagno xogta qaybaha kala duwan ee app-ka.
4.  **Screens (`lib/screens/`)**: Waa lakabka UI-ga (User Interface) ee qofku arkayo.
5.  **Widgets (`lib/widgets/`)**: Waa qaybo yar-yar oo dib loo isticmaali karo (Reusable Components).

---

## 🎨 Design System (Nidaamka Naqshadda)

Sida sharcigu qabay, waxaan isticmaalnay labo midab oo qura:
- **Primary Color**: Indigo (`#6366F1`) - Midabka rasmiga ah ee brand-ka.
- **Secondary Color**: Slate (`#64748B`) - Midabka labaad ee qoraalka iyo faahfaahinta.
- **Muuqaalka**: Waxaan hadda isticmaalnay **Light Mode** (Premium Slate & White) si uu app-ku u noqdo mid u furan indhaha (User Friendly).

---

## 🛠️ Backend Integration

App-kani wuxuu ku xiran yahay real backend:
- **Backend Tech**: Node.js, Express, MongoDB.
- **Operations**: Post fetching, Login/Register, Create/Edit/Delete posts.

---

## ✍️ Documentation

Dhammaan koodhka logic-ga ah waxaa lagu daray faallooyin (Comments) af-Somali ah si loo fududeeyo fahamka sida uu app-ku u shaqeynayo.

---

## 🚀 Sida loo socodsiiyo (Setup)

1.  Orod backend-ka: `cd backend && npm start`.
2.  Orod Flutter: `cd devblog_mobile && flutter run`.
