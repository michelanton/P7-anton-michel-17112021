<template>
  <div class="postCommentaire">
    <navGeneral></navGeneral>
    <h1 class="mt-2">Voici les commentaires de cet articles</h1>
     <!-- bouton retour aux posts --> 
    <button
      aria-label="Retour à la listes des articles"
      v-if="modeWriteComment == 'btnComment'"
      type="button"
      class="button  btn btn-warning m-3"
      @click.prevent="postReturn()">
      retour aux posts
    </button>
    <!-- cadre de l'article choisi -->
    <div class="date">
      <p>le {{post.date}}</p>
    </div> 
    <div class=" postCard "> 
     
        <!-- cadre user article -->
        <div class="  userinuse ">
          <div class="imgAvatar">
            <img :src="post.avatar_url" alt="avatar">
          </div> 
          <h2 class="pseudo mt-2" >Publyé par <strong class="">{{post.pseudo}}</strong></h2>
        </div>
        <h2 class="card-title mt-3">{{ post.title}}</h2>
        <div class="imgMedia mt-2">
          <img :src="post.media_url" alt="avatar">
        </div>
        <h3 class="card-text textArticle mt-4">{{post.description}}</h3>    
    </div>
    <!-- bouton Écrire un commentaire --> 
    <button
      aria-label="Ouvre la fenétre de rédaction d'un commentaire"
      v-if="modeWriteComment == 'btnComment'"
      type="submit"
      class="button  btn btn-warning m-3"
      @click.prevent="writeComment()">
      Écrire un commentaire
    </button>
    <!-- cadre ecrire commentaire --> 
    <section>
      <div class="postCard mt-3 mb-3" v-if="modeWriteComment == 'writeComment'">
          <textarea 
            placeholder="ecrivez votre message" 
            v-model="myCommentaire" 
            name="txtComment" 
            id="txtComment" 
            cols="50" 
            rows="3">
          </textarea>
          <!-- bouton ENVOYER --> 
          <button
            aria-label="Enregiste votre commentaire"
            type="submit"
            class="button  btn btn-warning m-3"
            @click.prevent="writingComment()">ENVOYER
          </button>
          <!-- bouton ANNULER --> 
          <button
            aria-label="Annule votre commentaire en cours"
            type="submit"
            class="button  btn btn-warning m-3"
            @click.prevent="annulComment()">ANNULER
          </button>
        </div>
    </section>
      <!-- cadre des commentaires sur cet article -->
    <section>
        <h3>Les comentaires</h3>
      <div class=" " :key="index" v-for="(comment, index) in comments">
        <div class="date">
          <p>le : {{comment.date}}</p>
        </div>
        <div class="postCard mb-4">
          <div class="userinuse">
            <div class="imgAvatar">
              <img :src="comment.avatar_url" alt="avatar">
            </div>
            <h3 class=" pseudo mt-2"> envoyé par : <strong> {{comment.pseudo}}</strong></h3>
          </div>
            <h3 class="commentaires mt-5">{{comment.comment}}</h3>
          <!-- <h6 class="card-text">{{comment}}</h6> -->
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
import 'dayjs/locale/fr' 
dayjs.locale('fr')
import localizedFormat  from 'dayjs/plugin/localizedFormat'
dayjs.extend(localizedFormat)

export default {
  name: "postCommentaires",
  data(){
    return{
      post: "",
      postId: "",
      userInfo: "",
      comments: [],
      modeWriteComment: "btnComment",
      myCommentaire: "",
    }
  },
   components: {
    navGeneral,
    leFooter
  },
  mounted(){
   
    this.postId = JSON.parse(localStorage.getItem('postInfo'));
    this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
    console.log(this.postId)
    console.log(this.userInfo)
    this.thePost();
    this.theComments();
   
   
  },
  methods : {

    annulComment(){
      this.modeWriteComment = 'btnComment'
    },
    postReturn() {
      this.$router.push({ name: "posts" });
    },
    //GET du post du user //  postIdCtrl()
    async thePost(){ 
      // console.log(this.postId)
      
      await axios 
        .get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/${this.postId}` , {
          headers: {
            'Authorization': `Bearer ${this.userInfo.token}`
          }
        })
        .then((response )=> { 
          // console.log("la reponse post id : ", response.data[0]);
          for (let i = 0; i < response.data.length; i++) {
            this.post = {
              id: response.data[i].id,
              avatar_url: response.data[i].avatar_url,
              pseudo: response.data[i].pseudo,
              title: response.data[i].title,
              description: response.data[i].description,
              media_url: response.data[i].media_url,
              date: dayjs(response.data[i].date).format('dddd D MMM YYYY [à] H[h]mm')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
            }
        }
    })
    },
    // GET touts les comment d'un post //  Pointe vers commentsIdCtrl()
    theComments(){
        axios
        .get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/comments/${this.postId}`, {
          headers: {
            'Authorization': `Bearer ${this.userInfo.token}`
          }
        })
        .then((res )=> { 
          console.log("la reponse comment id : ", res.data);
          
         
         for (let i = 0; i < res.data.length; i++) {
            this.comments.push({
              id: res.data[i].id_Comment,
              idUser: res.data[i].idUser,
              comment: res.data[i].comment,
              comUserID: res.data[i].userIdComment,
              pseudo: res.data[i].pseudo,
              avatar_url: res.data[i].avatar_url,
              date: dayjs(res.data[i].date).format('dddd D MMM YYYY [à] H[h]mm')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
            })
        }
          
          console.log(...res.data);
          // this.userData();
          //  this.commentaire();
          
        })
    },
    // display cadre écrire un comment
    writeComment(){
      this.modeWriteComment = "writeComment";
    },
      // POST d'un commentaire //  Pointe vers writingComment()
    writingComment(){
        let infoWriteComment = { 
          user_id: this.userInfo.id,
          post_id: this.postId,
          comment: this.myCommentaire,
          pseudo: this.userInfo.pseudo
          };
          console.log("info write comment", infoWriteComment);
          axios.post(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/comments/${this.post.id}`, infoWriteComment, {
            headers: {
              'Authorization': `Bearer ${this.userInfo.token}`
            }
          })
          .then((response)=> {
              if(response.status == 201){
                alert( 'publication réussie!');
              console.log('publication réussie!');
              location.reload()
              
          }
            if(response.status == 401){
          console.log("holala, ça n'a pas marché, dsl.");  
          }
        })
      
    },
    // GET d'un users //  commentPostCtrl()
    userCommnent(a){
        console.log(a);
        axios 
        .get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/post/comment/${a}` , {
          headers: {
            'Authorization': `Bearer ${this.userInfo.token}`
          }
        })
        .then((response )=> {
          console.log("la reponse uszer comment : ", response); 
          console.log("reponse avatar user comment  ",response.data[0]);
          this.userComment = response.data[0];
          console.log("le usercomment",this.userComment) ;
          // console.log(...res.data);
          // this.userData();
          //  this.commentaire();
          
        })

      // }
    
    } 
  }
}
</script>

<style scoped>

/* .postCommentaire{
  display: flex;
  flex-direction: column;
}

#user_list{
  margin: 0px auto 20px auto;
  max-width: 200px;
}
.usercard img {
  max-width: 150px;
}
.postCard {
  background-color: rgb(240, 232, 241);
  box-shadow: 2px 3px 10px #907497;
  border-radius: 15px;
  margin: 20px auto;
  padding: 20px 0px ;
  width: 80%;
 
}
.title {
  font-size: 35px;
  font-style: oblique;
}
textarea {
  background-color: rgb(238, 220, 241);
  box-shadow: 2px 3px 10px #563d7c;
  border-radius: 15px;
  width: 80%; 
  height:100px; 
  resize: none; 
  padding: 5px 20px 10px 30px;
}
.userCard{
  display: flex;
  flex-direction: row;
  background-color: rgb(252, 232, 224);
  box-shadow: 2px 3px 15px #9589a7;
  border-radius: 15px;
  width: 80%; 
  resize: none; 
  margin: 20px auto auto auto;
  
}
.userCard img {
  border-radius: 50%;
  width: 50px;
  margin: 10px 30px 30px 30px;
}
.userCard h5 {
  font-size: 12px;
}
.date{
 margin-left: 10px;
}
h1 {
    font-size: 25px;
    font-style: oblique;
  } */
/* .sendComment{
  display: flex;
  flex-direction: column;
  margin: auto;
} */
</style>