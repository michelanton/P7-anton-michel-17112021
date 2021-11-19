<template>
  <div class="hello">
    <navGeneral></navGeneral>
    <h1 class="title mt-2">Voici les derniers articles</h1>
    <!-- cadre utilisateur -->
    <div class=" userinuse mb-4 mt-4" >
      <div class="userAvatar">
        <img :src="user.avatar_url" alt="avatar">
      </div>
      <h2 class="pseudo mt-3">Bienvenue  <strong>{{user.pseudo}}</strong></h2>
    </div>
    <!-- bouton créer un article -->   
    <button 
      aria-label="Ouvre la fenetre de redaction d'un article"
      type="submit" 
      v-if="modePost == 'bouton'" 
      class="btn btn-warning mb-4 mt-2" 
      @click="createPost()">créer un article
    </button>
    <!-- cadre créer un article --> 
    <section class="createPost mb-4" v-if="modePost == 'createPost'">
      <h3>Créer un article</h3>
      <div class="  postCard">
        <!-- formulaire article -->  
        <form>
            <div class="choiseAvatar"> 
              <button 
                aria-label="Choisir le fichier à partager"
                type="button" 
                class="btn btn-primary btnfile"
                @click="boutonFile()">
                Choisir un fichier
              </button>
              <div class="imageUrl"  >
                <img :src="imageUrl" alt="">
              </div>
              <input 
                ref="inputFile"
                type="file"
                style="display:none" 
                @change="onFileSelected"
                class="form-control-file" 
                id="File" 
                accept=".jpg, .jpeg, .gif, .png" 
                name="image" />
            </div> 
            <input 
              type="text" 
              v-model="title"
              class="form-control" 
              placeholder="le titre"
              name="title">
            <textarea 
              id="exampleFormControlTextarea1" 
              rows="3"
              class="form-control " 
              v-model="myComment" 
              placeholder="le texte">
            </textarea>
        </form>
        <!-- bouton envoyé -->
        <button
          aria-label="Publier l'article" 
          type="submit"  
          class="button btn btn-warning m-2" 
          @click="sendPost()">Envoyer
        </button>
        <!-- bouton annulé -->
        <button 
          aria-label="Annule l'article en cours"
          type="submit"  
          class="button btn btn-warning m-2" 
          @click="annulPost()">Annuler
        </button>
      </div>
    </section> 
    <!-- cadre contenant chaque article -->
    <section>
      <h3>Tout les articles</h3>
      <div class=" mb-4" :key="index" v-for="(posts, index) in posts">
        <div class="date">
          <p class="date mt-1 mb-2">Envoyé le {{posts.date}}</p>
        </div>
        <div class="colorCadrePost ">
          <div class=" userinuse ">
            <div class="userAvatar">
              <img :src="posts.avatar_url" alt="{{posts.pseudo}}">
            </div>
              <h3 class=" pseudo mt-3">{{posts.pseudo}}</h3>
          </div>
          <h3 class="mt-3"><strong>{{ posts.title}}</strong></h3>
          <div class="imgMedia mt-4">
            <img :src="posts.media_url" alt="media">
          </div>
          <h3 class=" textArticle m-2">{{posts.description}}</h3>
          <h4 class="voirComments card__action mr-2 ml-2" 
              aria-label="Voir cet article avec ses commentaires" 
              @click="goPost(posts.id)">
            Voir les commentaires de cet article</h4>
        </div>  
      </div>
    </section>
    <leFooter></leFooter>
  </div> 
 
</template>

<script>
import axios from 'axios';
import PROTOCOLE from '../config/index.js'
import navGeneral from '../components/navGeneral.vue'
import leFooter from '../components/footer.vue'
import dayjs from 'dayjs'
import localizedFormat  from 'dayjs/plugin/localizedFormat'
import 'dayjs/locale/fr' 

dayjs.locale('fr')
dayjs.extend(localizedFormat)

export default {
  name: "posts",
  data(){
    return {
      modePost : "bouton",
      modeComment : "",
      posts: [],
      userEmail : "",
      user : [],
      pseudo: "",
      id: "",
      token : "",
      myComment:'',
      title: "",
      imageUrl :"",
      image: null
    }
  },
  components: {
    navGeneral,
    leFooter
  },
  mounted(){ 
    const userInfo = JSON.parse(localStorage.getItem('userInfo')); 
    if (userInfo) { 
      this.email = userInfo.email;
      this.token = userInfo.token;
      this.id = userInfo.id;
      this.getallpost();
      this.userData(); 
    } else {
      this.$router.push({ name: "to404" });
    }
  },
  methods : {
     // GET touts les posts //  Pointe vers allPosts()
    getallpost(){
     axios
      .get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts` , {
        headers: {
          'Authorization': `Bearer ${this.token}`
        }
      })
      .then((res )=> { 
        console.log(res); 
      
        if (res.status == 200) {
        // this.posts = res.data 
          for (let i = 0; i < res.data.length; i++) {
            this.posts.push({
              id: res.data[i].post_id,
              avatar_url: res.data[i].avatar_url,
              pseudo: res.data[i].pseudo,
              title: JSON.parse(res.data[i].title),
              description: JSON.parse(res.data[i].description),
              media_url: res.data[i].media_url,
              date: dayjs(res.data[i].date_post).format('ddd D MMM YYYY [à] H[h]mm ')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
            })
          let PourStorage = JSON.parse(localStorage.getItem("userInfo"));
          this.userEmail = PourStorage.email
          this.token = PourStorage.token
          //  console.log(PourStorage); 
          }
        } else if (res.status == 409) {
          console.loc("res 409");
        } else  {
          console.log("router psuh");
          this.$router.push({ name: "to404" });
        }
      })
    },
    // GET un user //  Pointe vers userEmail()
    async userData(){
      // console.log(this.email);
      await   axios
      .get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/users/${this.email}`,  {
        headers: {
          'Authorization': `Bearer ${this.token}`
        }
      })
      .then((res )=> {
        this.user = res.data[0]
        console.log("this User :", this.user);
      })
    },
    // PUSH vers "postCommentaire" //  Pointe vers allPosts()
    goPost(a){ 
     localStorage.setItem("postInfo", JSON.stringify(a));
     this.$router.push({ name: "postCommentaires" });
    },
    // MODIF display vers créer un post //  
    createPost(){
      this.modePost = 'createPost'
    },
    // DELETE un post //  Pointe vers supPostCtrl()
    annulPost(){
      this.modePost = 'bouton'
    },
    // choix image
    onFileSelected(event) {
      const files = event.target.files
      let filename = files[0].name;
      if ( filename.lastIndexOf('.') <= 0) {
        return alert("ce n'est pas un fichier valide")
      }
      const fileReader = new FileReader()
      fileReader.addEventListener('load', () => {
        this.imageUrl = fileReader.result;
      })
      fileReader.readAsDataURL(files[0])
      this.image = files[0]
    },
    // GET un post
    sendPost(){
      if ( !this.image ||  this.newMessage > 1500 ) {
              console.log("il n'y a pas d'image ou le texte est trop long");        
      } else {
          const formData = new FormData()
          formData.append("image", this.image);
          formData.append("description", JSON.stringify(this.myComment));
          formData.append("title", JSON.stringify(this.title));
          formData.append("user", JSON.stringify(this.id)); 
          axios.post(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts`, formData, {
            headers: {
              'Authorization': `Bearer ${this.token}`
            }
          })
          .then((response)=> {
            if (response.status == 201){
              alert('publication réussie!')
              location.reload()
            }
            if (response.status == 401)
            {
              console.log("holala, ça n'a pas marché, dsl");  
            }
          })
          .catch((error) => {
            console.log(error);
          })
      }
    },
    // choix image
    boutonFile() {
      this.$refs.inputFile.click()
    }
  }
}
  

</script>

<style>

.form-control{
  margin: 0px auto 20px auto;
  width: 80%;
}
img{
  width: 150px;
  margin: auto;
}
.choiseAvatar{
  padding: 10px;
  border: 1px solid rgb(187, 184, 184);
  box-shadow: -1px 1px 10px #b4b9e6;
  border-radius: 5px;
  width: 80%;
  margin: 10px auto;
}
.postCard {
  background-color: rgb(255, 252, 248);
  box-shadow: -1px 1px 10px #b4b9e6;
  border-radius: 15px;
  margin: 0px auto;
  padding: 20px 0px ;
  width: 80%;
  overflow-wrap: break-word;
}
.colorCadrePost {
  background-color: rgb(247, 244, 241);
  padding: 10px 0px 10px 0px;
  box-shadow: -1px 1px 10px #b4b9e6;
  border-radius: 15px;
  margin: 0px auto;
  width: 80%;
  overflow-wrap: break-word;
}
.userAvatar img, .imgAvatar img {
  border-radius: 50%;
  border: 1px solid rgb(133, 162, 241);
  width: 50px;
  height: 50px;
  margin: 5px 10px 5px 5px;
  float: left;
}
.imageUrl img {
  width: 90px;
  margin: 20px;
}
.imgMedia {
  height: 75%;
  max-width: 200px;
  margin: 0px auto 0px auto;
}
.imgMedia img {
  width:  100%;
}
.imgProfil img {
  width: 80px;
  margin: 0px auto 10px auto;
}
.userinuse {
  background-color: rgb(252, 239, 217);
  box-shadow: 1px 3px 15px #9589a7;
  border-radius: 15px;
  width: 95%;
  height: 60px;
  margin: 0px auto 10px auto;
}
.textArticle {
  padding: 0px 15px;
}
.userinuse h3 {
 font-size: 16px;
 
}
.userinuse strong {
 font-size: 24px;
}
.cadreArticle{
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  justify-items: center;
}
textarea, input, .boutonFile {
  background-color: rgb(250, 243, 231);
  box-shadow: 1px 3px 10px #3d537c;
  border-radius: 15px;
  width: 80%; 
  height:100px; 
  resize: none; 
  padding: 5px 20px 10px 30px;
  margin: 0px auto 20px auto;
}
.pseudo {
  float: left;
  margin-left: 20px;
  font-size: 20px;
  font-weight: bold;
}
.date {
  font-size: 14px;
  margin-right: 10px;
}
.title{
  margin: 0px auto 0px auto;
  font-weight: bold;
  font-size: 22px ;
}
.btnfile{
  margin: 20px auto;
}
.commentaires {
  margin: 10px;
}
.voirComments {
  color: #0444b9;
  cursor: pointer;
  font-size: 16px ;
}
.voirComments:hover {
  color:#f39324 ;
}
.profiEmail {
  font-size: 16px;
}
.profiPseudo {
  font-size: 22px;
}

</style>