<template>
  <div class="postCommentaire">
     <navSuperUser></navSuperUser>
     <h1 class="mt-2">L'article choisi avec ses commentaires</h1>
     <!-- cadre USER article --> 
    
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
          @click="supPost(post.id)">supprimer cet article
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
   
    this.postId = JSON.parse(localStorage.getItem('postInfo'));
    this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
    console.log(this.postId)
    // console.log(this.userInfo)
    this.thePost();
    this.theComments();
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
      // console.log(this.postId)
      await axios 
        .get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/${this.postId}` , {
          headers: {
            'Authorization': `Bearer ${this.userInfo.token}`
          }
        })
        .then((response )=> { 
          console.log("la reponse post id : ", response.data[0]);
          // this.post = response.data[0];
                    this.post = {
                        id: response.data[0].postID,
                        avatar_url: response.data[0].avatar_url,
                        pseudo: response.data[0].pseudo,
                        title: JSON.parse(response.data[0].title),
                        description: JSON.parse(response.data[0].description),
                        media_url: response.data[0].media_url,
                        date: dayjs(response.data[0].date).format('ddd D MMM YYYY [à] H[h]mm ')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
                    } 
           console.log("this post", this.post); 
          // console.log(...res.data);
          // this.userData();
          //  this.commentaire();
          
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
                    // location.reload();
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
          // this.comments = res.data;
          //  console.log(PourStorage); 
          // console.log(...res.data);
          // this.userData();
          //  this.commentaire();
          
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
    
    
    },
    // DELETE un comment
    supComment(a){
        // console.log(a);
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
                // location.reload()
                
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

/* .postCommentaire{
  display: flex;
  flex-direction: column;
  
}
h6 {
    font-size: 12px;
}
.pseudo {
  font-size: 20px;
}

#user_list{
  margin: 0px auto 20px auto;
  max-width: 200px;
}
.postCard {
  background-color: rgb(240, 232, 241);
  box-shadow: 2px 3px 10px #907497;
  border-radius: 15px;
  margin: 20px auto;
  padding: 20px 0px ;
  width: 80%;
 
}
.commentCard {
   background-color: rgb(240, 232, 241);
  box-shadow: 2px 3px 10px #907497;
  border-radius: 15px;
  margin: 20px auto;
  padding: 20px 0px ;
  width: 80%;
}
.postCard img {
 width: 60%;
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
  overflow: hidden;
}
.date{
 margin-left: 10px;
}
h1 {
    font-size: 25px;
    font-style: oblique;
    overflow: hidden;
  } */
  

</style>