<template>
  <div class="container  mt-4">
    <navHome></navHome>
      <div class="card general">
        <!-- conditionnelle d'affichage -->
        <div class="container mt-4">
          <h1 class="card__title titre" v-if="mode == 'loGin'">CONNEXION</h1>
          <h2 class="card__title acceuil1" v-if="mode == 'loGin'">Bienvenue sur notre <span class="bulle">bulle</span> de discussion <strong>Gourpomania</strong></h2>
          <h2 class="card__title titre" v-if="mode == 'inscription'">INSCIPTION</h2>
          <p class="paragraph" v-if="mode == 'loGin'">
            vous n'avez pas encore de compte ?
            <span class="appel card__action" aria-label="accéder à la page d'inscription" @click="goInscription()"><br/>
              <strong >Créer un compte</strong>
            </span>
          </p>
          <p class="paragraph" v-if="mode == 'inscription'">
            tu as deja un compte ?
            <span class="appel card__action" aria-label="accéder à la page de Login" @click="goLogin()"> <br/>
              <strong>Log toi</strong>
            </span>
          </p>
        
        </div>
        <!-- affichage -->
        <div class="container mt-4">
          <!-- formulaire de signup -->
          <form>
            <!-- input file image -->
            <input
                ref="fileInput"
                style="display: none"
                type="file"
                name="file"
                @change="fileSelected"
                class="form-control-file ml-5"
                required
                accept="image/*"
              />
              <!-- bouton de choisx image -->
              <div class="choiseAvatar" v-if="mode == 'inscription'">
                <button 
                  aria-label="Choisr son avatar"
                  type="button" 
                  class="btn btn-outline-primary" 
                  @click="onAvatar">choisir avatar
                </button>
                <div class="imageUrl"  >
                  <img :src="imageUrl" alt="">
                </div>
              </div>
              <!--  pseudo -->
              <div v-if="mode == 'inscription'" class="form-group">
                <label for="pseudo">
                  pseudo 
                </label>
                <input
                  type="pseudo"
                  v-model="user.pseudo"
                  class="form-control form-row__input"
                  id="pseudo"
                  placeholder="pseudo"
                  required
                  name="pseudo"/>
              </div>
                <!-- login email / password -->
              <div class="form-group">
                <label for="email">
                  email 
                </label>
                <input
                  type="email"
                  name="email"
                  v-model="user.email"
                  class="form-control form-row__input"
                  id="email"
                  placeholder="Enter email"
                  required/>
              </div>
              <!-- login password --> 
              <div class="form-group">
                <label for="password">
                  password 
                </label>
                <input
                  type="password"
                  name="password"
                  v-model="user.password"
                  class="form-control form-row__input"
                  id="password"
                  placeholder="password"
                  required />
                <p v-if="mode == 'inscription'">
                  Le mot de passe doit inclure au moins 8 caractères dont au moins 1
                  minuscule, 1 majuscule, 1 chiffre, et 1 caractère spécial
                </p>
              </div>
              <!-- password Confirm -->
              <div class="form-group" v-if="mode == 'inscription'" >
                <label for="passwordConfirm">
                  password Confirm
                </label>
                <input
                  type="password"
                  name="passwordConfirm"
                  v-model="user.passwordConfirm"
                  class="form-control form-row__input"
                  id="passwordConfirm"
                  placeholder="password Confirm"
                  required
                />
              </div>
              <h2 class="title mt-2" v-if="mode == 'signup'">
                <strong> Cliquez sur <span class="connexion"> connexion</span> pour entrée !!</strong>
              </h2>

              <!-- bouton conditionel -->
              <button
                aria-label="Connexion au site"
                v-if="mode == 'loGin'"
                type="submit"
                class="button btn btn-primary mb-3"
                @click.prevent="login()">
                  <strong>connexion</strong>
                </button>
              <button
                aria-label="Enregistrement de votre profil"
                v-if="mode == 'inscription'"
                type="submit"
                class="button  btn btn-success m-3"
                @click.prevent="signup()">
              <strong>connexion</strong> 
              </button>
              <button
                aria-label="Connexion au site"
                v-if="mode == 'signup'"
                type="submit"
                class="button  btn btn-warning mb-3"
                @click.prevent="login()">
                <strong>connexion</strong> 
              </button>
              
          </form>
        </div>
      </div>
  </div>
</template>

<script>
import axios from "axios";
import PROTOCOLE from '../config/index.js'
import navHome from '../components/navHome.vue'

export default {
  name: "login",
  data() {
    return {
      Active: true,
      mode: "loGin",
      selectedFile: null,
      user: {
        email: "",
        password: "",
        passwordConfirm: "",
        pseudo: ""
      },
      imageUrl: ""
    };
  },
  components: {
   navHome
  },
  methods: {
    // PUSH vers login
    goRefresh() {
     this.$router.push({ name: "login" });
    },
     // DISPLAY mode incription
    goInscription() {
      this.mode = "inscription";
    },
      // DISPLAY mode loGin
    goLogin() {
      this.mode = "loGin";
    },
    // REF file input click
    onAvatar(){
      this.$refs.fileInput.click()
    },
    // input file, image avatar
    fileSelected(event) {
      const files = event.target.files;
      let filename = files[0].name;
       if (filename.lastIndexOf('.') <= 0) 
      {
        return alert("ce n'est pas un fichier valide, dsl.")
      }
      const fileReader = new FileReader()
      fileReader.addEventListener('load', () => {
        this.imageUrl = fileReader.result;
       
      })
      fileReader.readAsDataURL(files[0]);
      this.selectedFile = files[0]
      // console.log("FILES [0]", files[0]);
    },
    //SIGNUP
    async signup() {
      if ( this.user.password !== this.user.passwordConfirm ) {
        alert("les mots de passe sont differents !!");
        location.reload()
      } 
      const fd = new FormData();
        fd.append('image', this.selectedFile);
        fd.append('userEmail', this.user.email );
        fd.append('userPassword', this.user.password );
        fd.append('userPasswordConfirm', this.user.passwordConfirm );
        fd.append('userPseudo', this.user.pseudo );
          // console.log("la forme data : ", fd);
      await axios
        .post(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/signup`, fd)
          .then((response) => {
            console.log("la reponse est 201 : " + response.error);
            if (response.status == 201) {
              localStorage.setItem("userInfo", JSON.stringify(this.user));
              console.log("utilisateur créé... welcome");
              alert("utilisateur créé... welcome");
              this.mode = "signup";
            }
            if (response.status == 409) {
              alert("cet email est deja enregistré");
              this.$router.push({ name: "login" });
            }
          })
        .catch((error) => {
          console.log("la reponse est 201 : " + error);
          alert("le mot de passe ne replis pas les conditions");
          location.reload()
        });
      
    },
    // LOGIN
    async login() {
      await axios.post(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/login`, this.user)
      .then((response) => {
        // console.log("la response post login 200: ", response);
        if (response.status == 200) {
          const userInfo = {
            email: this.user.email,
            token: response.data.token,
            id: response.data.id,
            pseudo: response.data.pseudo
          };
          localStorage.setItem("userInfo", JSON.stringify(userInfo));
          this.$router.push({ name: "posts" });
        } 
        // console.log("la response 202 est : ", response);
        if (response.status == 202) {
          const userInfo = {
            email: this.user.email,
            token: response.data.token,
            id: response.data.id,
          };
          localStorage.setItem("userInfo", JSON.stringify(userInfo));
          this.$router.push({ name: "superUser" });
        } 
        if (response.status == 401) {
          console.log("la response 401 est : ", response);
        }
      })
      .catch(error => {
        alert(error.response.data.error);
        location.reload()
        // console.dir(error.response.data)
      })
    },
  },
};
</script>

<style scoped>

.titre {

  font-size: 36px;
}
.acceuil1 {
  font-family: "Anton";
  font-size: 20px;
}
.paragraph {
  font-family: "Anton";
  font-size: 16px;
}
.msg {
  font-family: "Anton";
  font-size: 20px;
  color: red;
}
.form-control {
  margin: 0px auto 20px auto;
 
}
.appel {
  color: rgb(228, 3, 3);
}
.appel:hover {
  cursor: pointer;
}
.imageUrl img {

  width: 90px;
  margin: 20px;
}
.choiseAvatar{

  padding: 10px;
  border: 1px solid rgb(187, 184, 184);
  border-radius: 5px;
  
}
.connexion {
  color: rgb(6, 67, 197);
}
.general {
  background-color: #eeeae5;
}
</style>
