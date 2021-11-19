<template>
  <div class="postCommentaire">
    <navGeneral></navGeneral>
    <h1 class="title mt-2">Voici les commentaires de cet articles</h1>
     <!-- bouton retour aux posts --> 
    <button
      aria-label="Retour à la listes des articles"
      v-if="modeWriteComment == 'btnComment'"
      type="button"
      class="button  btn btn-warning m-3"
      @click.prevent="postReturn()">
      retour aux articles
    </button>
    <!-- cadre de l'article choisi -->
    <div class="date">
      <p>le {{post.postDate}}</p>
    </div> 
     <!-- cadre user article -->
    <div class=" postCard "> 
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
        <h3 class="title mt-3">Les comentaires :</h3>
        <!-- bouton Écrire un commentaire --> 
         <button
            aria-label="Ouvre la fenétre de rédaction d'un commentaire"
            v-if="modeWriteComment == 'btnComment'"
            type="submit"
            class="button  btn btn-warning m-3"
            @click.prevent="writeComment()">
            Écrire un commentaire
          </button>
      <div class=" " :key="index" v-for="(comment, index) in comments">
        <div class="date">
          <p>le : {{comment.dateComment}}</p>
        </div>
        <div class="postCard mb-4">
          <div class="userinuse">
            <div class="imgAvatar">
              <img :src="comment.avatar_url" alt="avatar">
            </div>
            <h3 class=" pseudo mt-2"> envoyé par : <strong> {{comment.pseudo}}</strong></h3>
          </div>
          <h3 class="commentaires mt-5">{{comment.comment}}</h3>
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
    const userInfo = JSON.parse(localStorage.getItem('userInfo'));
    if (userInfo) { 
      this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
      this.postId = JSON.parse(localStorage.getItem('postInfo'));
      console.log("pOstID", this.postId)
      console.log("UserInfo", this.userInfo)
      this.thePost();
      this.theComments();
    } else {
      this.$router.push({ name: "to404" });
    }
   
   
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
      await axios 
        .get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/${this.postId}` , {
          headers: {
            'Authorization': `Bearer ${this.userInfo.token}`
          }
        })
        .then((response )=> { 
          for (let i = 0; i < response.data.length; i++) {
            this.post = {
              id: response.data[i].postID,
              avatar_url: response.data[i].avatar_url,
              pseudo: response.data[i].pseudo,
              title: response.data[i].title,
              description: response.data[i].description,
              media_url: response.data[i].media_url,
              postDate: dayjs(response.data[i].postDate).format('dddd D MMM YYYY [à] H[h]mm')  
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
                dateComment: dayjs(res.data[i].dateComment).format('dddd D MMM YYYY [à] H[h]mm')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
              })
          }
          
          console.log(...res.data);
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
        })
    } 
  }
}
</script>

<style scoped>


</style>