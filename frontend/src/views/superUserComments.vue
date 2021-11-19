<template>
  <div class="postCommentaire">
     <navSuperUser></navSuperUser>
     <h1 class="mt-2">L'article choisi avec ses commentaires</h1>
     <!-- bouton retour a ADMIN --> 
    <button
      aria-label="Retour à l'accueil administrateur"
      v-if="modeWriteComment == 'btnComment'"
      type="button"
      class="button  btn btn-warning m-3"
      @click.prevent="superUserReturn()">
        retour ADMIN
    </button>
        <!-- cadre de l'article choisi -->
    <section class="mb-3" >
      <div class="date mb-3">
        <p>Crée le : {{post.date}}</p>
      </div>
      <div class=" colorCadrePost  "> 
        <div class="userinuse mb-3">
          <div class="userAvatar">
            <img :src="post.avatar_url" alt="avatar">
          </div> 
          <h5 class=" pseudo mt-2">Publyé par <strong>{{post.pseudo}}</strong></h5>
        </div>
        <h2 class="card-title m-1">{{post.title }}</h2>
        <div class="imgMedia">
          <img :src="post.media_url" alt="media">
        </div>
        <h4 class="m-3">{{post.description}}</h4> 
        <button
          aria-label="supprimer l'article"
          type="submit"
          class="button  btn btn-danger m-3"
          @click="supPost(post.postID)">supprimer cet article
        </button> 
        <button
          aria-label="Retour à l'accueil administrateur"
          type="submit"
          class="button  btn btn-warning m-3"
          @click="superUserReturn()">RETOUR
        </button>
      </div>
    </section>
    <!-- cadre des commentaires sur cet article -->
    <section class="postCard mb-4 " :key="index" v-for="(comment, index) in comments">
      <div class="date">
        <p>le : {{comment.date}}</p>
      </div>
      <div class=" userinuse">
        <div class="userAvatar">
          <img :src="comment.avatar_user" alt="avatar">
        </div>
        <h6 class=" pseudo mt-2">envoyé par : <strong>{{comment.pseudo}}</strong></h6>
      </div>
      <h3 class="commentaires">{{comment.comment}}</h3>
      <!-- <h6 class="card-text">{{comment}}</h6> -->
      <button
        aria-label="Supprimer le commentaire"
        type="submit"
        class="button  btn btn-danger m-3"
        @click="supComment(comment.comID)">supprimer ce commentaire
      </button> 
      <button
        aria-label="Retour à l'accueil administrateur"
        type="submit"
        class="button  btn btn-warning m-3"
        @click="superUserReturn()">RETOUR
      </button>
    </section>
  </div>
</template>

<script>
import axios from 'axios';
import PROTOCOLE from '../config/index.js'
import navSuperUser from '../components/navSuperUser.vue'
import dayjs from 'dayjs'
import localizedFormat  from 'dayjs/plugin/localizedFormat'
import 'dayjs/locale/fr' 

dayjs.locale('fr')
dayjs.extend(localizedFormat)

export default {
  name: "superUserComments",
  data(){
    return{
      post: "",
      postId: "",
      userInfo: "",
      comments: [],
      modeWriteComment: "btnComment",
      myCommentaire: ""
    }
  },
   components: {
    navSuperUser
  },
  mounted(){
     const userInfo = JSON.parse(localStorage.getItem('userInfo'));
        if (userInfo) { 
          this.postId = JSON.parse(localStorage.getItem('postInfo'));
          this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
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
    superUserReturn() {
      this.$router.push({ name: "superUser" });
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
          console.log("la reponse post id : ", response.data[0]);
                    this.post = {
                        postID: response.data[0].postID,
                        avatar_url: response.data[0].avatar_url,
                        pseudo: response.data[0].pseudo,
                        title: JSON.parse(response.data[0].title),
                        description: JSON.parse(response.data[0].description),
                        media_url: response.data[0].media_url,
                        date: dayjs(response.data[0].date).format('ddd D MMM YYYY [à] H[h]mm ')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
                    } 
           console.log("this post", this.post); 
        })
        .catch((error) => {
          console.log(error);
        })
    },
    // DELETE un post  //  supPostCtrl()
    supPost(a){
        console.log(a);
        if (window.confirm( "Voulez-vous vraiment supprimer cet article ? \n" + 
                  "OK pour supprimer")) 
        {
            axios.delete(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/${a}` , {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
            })
            .then((response ) => { 
                console.log("response :", response)
                if (response.status == 200) { 
                    alert("l'article a été supprimé..  "); 
                    console.log("l'article a été supprimé..  ");
                    this.$router.push({ name: "superUser" });
                }               
            }) 
            .catch ((error) => {
                alert(error);
            })
        } else {
            location.reload();
        }
    },
    // GET touts les comment d'un post //  Pointe vers commentsIdCtrl()
    async theComments(){
        await axios
        .get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/comments/${this.postId}`, {
          headers: {
            'Authorization': `Bearer ${this.userInfo.token}`
          }
        })
        .then((res )=> { 
          console.log("la reponse comment id : ", res.data);
          for (let k = 0; k < res.data.length; k++) {
            this.comments.push({
              id: res.data[k].comID,
              pseudo: res.data[k].pseudo,
              comment: res.data[k].comment,
              avatar_user: res.data[k].avatar_url,
              date: dayjs(res.data[k].date_post).format('ddd D MMM YYYY [à] H[h]mm ')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
            })
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

      // }
    
    
    },
    // DELETE un comment
    supComment(a){
        if (window.confirm( "vVoulez-vous vraiment supprimer ce commentaire ?\n" + 
                  "OK pour le suppriomer")) 
        {
            axios.delete(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/comments/${a}` , {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
            })
            .then((response )=> { 
                console.log(response)
                if (response.status == 200) { 
                alert("le post a été supprimé..  "); 
                console.log("le post a été supprimé..  ");
                this.$router.push({ name: "superUser" });
                }               
            })
            .catch((error) => {
                console.log(error);
            })
        } else {
            location.reload()
        }
         
    }, 
  }
}
</script>

<style scoped>

</style>