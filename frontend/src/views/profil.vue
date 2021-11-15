<template>
<div class="contener">
    <navGeneral></navGeneral>
    <div class="card ">
        <h1 class="card__title mt-2">Mon profil</h1>
         <!-- bouton retour aux articles -->
            <button
                aria-label="Retour à la liste des articles"
                type="button"
                class="button one btn btn-warning m-1"
                @click.prevent="postReturn()">Retour aux articles
            </button>
        <!-- cadre profil -->
        <section class=" mb-4 mt-4 postCard">
            <div class="imgProfil">
              <img :src="user.avatar_url" alt="avatar">
            </div>
            <h2 class="profiPseudo">Pseudo : <strong>{{ user.pseudo }}</strong> </h2>
            <h3 class="profiEmail">Email :{{ user.email }}</h3>
             <!-- boutons -->
            <div class="" v-if="btnActif == 'btnActif'">
            
                <!-- bouton Voir tout mes articles -->
                <button
                    aria-label="CVoir tout mes articles"
                    type="submit"
                    class="button two btn btn-warning m-1"
                    @click="goArticle()">Mes articles
                </button>
                <!-- bouton Voir tout mes commentaires -->
                <button
                    aria-label="Voir tout mes commentaires"
                    type="submit"
                    class="button three btn btn-warning m-1"
                    @click="goComment()">Mes commentaires
                </button>
                <!-- Supprimer mon profil -->
                <button
                    aria-label="Supprime votre profil"
                    type="submit"
                    class="button  btn btn-danger m-1"
                    @click="supUser()">Supprimer mon profil
                </button>
            </div>
        </section>
            <!-- tout mes articles postés -->
        <div v-if="modeArticle == 'articles'">
            <!-- bouton retour -->
            <button
                aria-label="Retour à l'accueil' profil"
                type="submit"
                class="button  btn btn-warning m-3"
                @click="annulArticle()">Retour
            </button>
            <!-- cadre chaques articles -->
            <section class=" mb-4" :key="index" v-for="(posts, index) in post">
                <div class="postCard">
                    <div class="date">
                        <p>créé le : {{ posts.date }}</p>
                    </div>
                    <div class="imgMedia mt-4">
                        <img :src="posts.media_url" alt="media">
                    </div>
                    <h3>{{JSON.parse(posts.title)}}</h3>
                    <h4>{{ JSON.parse(posts.description) }}</h4>
                    <!-- bouton Suprimé le post -->
                    <button
                        aria-label="Supprime l'article"
                        type="submit"
                        class="button  btn btn-warning m-3"
                        @click="supPost(posts.id)">Suprimer l'article'
                    </button>
                    <!-- bouton RETOUR -->
                    <button
                        aria-label="Retour à l'accueil' profil"
                        type="submit"
                        class="button  btn btn-warning m-3"
                        @click="annulArticle()">Retour
                    </button>
                </div>
            </section>
        </div>
        <!-- tout mes commentaires postés -->
        <section v-if="modeComment == 'comments'">
            <!-- bouton RETOUR -->
            <button
                aria-label="Retour à l'accueil' profil"
                type="submit"
                class="button  btn btn-warning m-3"
                @click="annulArticle()">Retour
            </button>
            <!-- cadre chaques comments -->
            <div class=" card__title  mb-4 postCard"  :key="index" v-for="(comments, index) in comment" >
                <div class="postCard">
                     <div class="date">
                        <p>date du post : {{ comments.date }}</p>
                    </div>
                    <h3 class="title">{{JSON.parse(comments.title ) }}</h3>
                    <div class="imgMedia">
                        <img :src="comments.media_url" alt="avatar">
                    </div>
                    <h4 class="m-2"> {{ JSON.parse(comments.description) }}</h4>
                </div>
                <div class="postCard mt-3 mb-3">
                    <h5>{{ comments.comment }}</h5>
                </div>
                <button
                    aria-label="Supprime le commentaire"
                    type="submit"
                    class="button  btn btn-danger mb-3"
                    @click="supComment(comments.id)">Suprimer le commentaire
                </button>
            </div>
        </section>
    </div>
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
    name: "profil",
    data() {
        return {
            userInfo: "",
            user: [],
            newUser: [],
            post: [],
            comment: [],
            modeArticle: "",
            modeComment: "",
            modeProfil: "",
            avatarModif: "",
            btnActif: "btnActif"
        } 
    },
    components: {
        navGeneral,
        leFooter
    },
    mounted(){
        this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
        this.profil();
        this.articles();
        this.comments();
    },
    methods : {
        // modif display voir les articles
        goArticle(){
            this.btnActif = "inactif";
            this.modeArticle = "articles";
            
        },
        // modif displpay voir les comments
        goComment(){
            this.btnActif = "inactif";
            this.modeComment = "comments";
            
        },
        // retour a la page posts
        postReturn() {
            this.$router.push({ name: "posts" });
        },
        // GET sur le user // postsRoute userEmail()
        async profil(){
            await axios.get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/users/${this.userInfo.email}`,  {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
            })
            .then((res )=> {
                this.user = res.data[0];
                console.log("la reponse profil : ", res.data[0]);
            })
        },
        // DELETE le user
        supUser(){
    
            if (window.confirm( "Vous étes sur le point de supprimer votre profil \n" + 
                  "Pour supprimer le profil : cliquez OK \n" +
                  "ANNULER pour revenir au profil"
            )) 
            {
                axios.delete(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/users/${this.userInfo.id}` , {
                    headers: {
                        'Authorization': `Bearer ${this.userInfo.token}`
                    }
                })
                .then((response )=> { 
                    console.log(response)
                    if (response.status == 200) { 
                    
                        alert("le User a été supprimé..  "); 
                        console.log("le User a été supprimé..  ");
                        localStorage.clear();
                        this.$router.push({ name: "login" });
                    
                    }               
                })
                .catch((error) => {
                    console.log(error)
                })
            } else {
            location.reload(); 
            }
        },
        // GET tout les articles d'un user // postUserIdCtrl()
        async articles(){
            console.log(this.userInfo.id)
            await axios.get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/user/${this.userInfo.id}` , {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
                })
                .then((response )=> { 
                console.log("la reponse article : ", response.data);
                    for (let i = 0; i < response.data.length; i++) {
                        this.post.push({
                            id: response.data[i].id,
                            pseudo: response.data[i].pseudo,
                            title:  response.data[i].title,
                            description: response.data[i].description,
                            media_url: response.data[i].media_url,
                            date: dayjs(response.data[i].date).format('ddd D MMM YYYY [à] H[h]mm ')  //dayjs(response.data[i].date_post).format('L')  //res.data[i].date_post
                        })
                        //  console.log("les posts", this.post); 
                        // console.log(...res.data);
                        // this.userData();
                        //  this.commentaire();
                
                    }
                })
        },
        // refresh page
        annulArticle(){
            location.reload()
        },
        // GET sur tout les comments d'un user // 
        async comments(){
            // console.log(this.userInfo.id);
            await axios.get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/user/comment/${this.userInfo.id}` , {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
                })
                .then((reponse )=> { 
                console.log("la reponse comment : ", reponse.data);
                    for (let i = 0; i < reponse.data.length; i++) {
                        this.comment.push({
                            id: reponse.data[i].id,
                            title: reponse.data[i].title,
                            comment: reponse.data[i].comment,
                            description: reponse.data[i].description,
                            media_url: reponse.data[i].media_url,
                            date: dayjs(reponse.data[i].date_post).format('ddd D MMM YYYY [à] H[h]mm ')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
                        })
                    }
                })
        },
        // DELETE un post  //  supPostCtrl()
        supPost(a){
            console.log(a);
            if (window.confirm( "Vous étes sur le point de supprimer votre article \n" + 
                  "Pour supprimer l'article : cliquez OK \n" +
                  "ANNULER pour revenir au profil")) 
                  {
              axios.delete(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts/${a}` , {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
             })
                .then((response )=> { 
                    console.log("la reponse: ", response.status)
                    if (response) { 
                    alert("le post a été supprimé..  "); 
                    console.log("le post a été supprimé..  ");
                    location.reload();
                    }               
                })
            } else {
              location.reload();
            }
        },
        // DELETE un comment
        supComment(a){
            // console.log(a);
            if (window.confirm( "Vous etes sur le point de supprimmer votre commantaire\n" + 
                  "Pour supprimer ce commentaire : cliquez OK \n" +
                  "ANNULER pour revenir au profil")) 
                  {
                        axios.delete(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/comments/${a}` , {
                            headers: {
                                'Authorization': `Bearer ${this.userInfo.token}`
                            }
                        })
                        .then((response )=> { 
                            console.log(response)
                            if (response.status == 200) { 
                                alert("le commentaire a été supprimé..  "); 
                                console.log("le commentaire a été supprimé..  ");
                                location.reload()
                            }               
                        })
                        .catch((error) => {
                        console.log(error)
                        })
                    } else {
                        location.reload(); 
                    }
             
        },
    }
}
</script>

<style scoped>

/* img , button{
    max-width: 150px;
    margin : auto
}

.postCard {
  background-color: rgb(250, 231, 243);;
  
  box-shadow: 2px 3px 10px #563d7c;
  border-radius: 15px;
  margin: 20px auto;
  padding: 20px 0px ;
  width: 80%;
 
}
.cadreArticle{
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  justify-items: center;
}
textarea, input {
  background-color: rgb(238, 220, 241);
  box-shadow: 6px 6px 10px #563d7c;
  border-radius: 15px;
  width: 80%; 
  height:100px; 
  resize: none; 
  padding: 5px 20px 10px 30px;
  margin: 0px auto 20px auto;
} */


</style>