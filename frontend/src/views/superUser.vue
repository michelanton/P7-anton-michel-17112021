<template>
<div class="contener">
    <navSuperUser></navSuperUser>
    <div class="card ">
        <!-- cadre profil -->
        <div class=" mb-4 mt-4 postCard">
            <h1 class="card__title mb-4">ADMIN</h1>
            <img :src="user.avatar_url" alt="avatar">
            <h2><strong>{{ user.pseudo }}</strong> </h2>
        </div>
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
        <!-- boutons -->
        <div class="btn-group-vertical m-1 p-1" v-if="btnActif == 'btnActif'">
              <!-- bouton Voir tout mes articles -->
            <button
                aria-label="Voir tout les articles"
                type="submit"
                class="button two btn btn-warning mb-2"
                @click="goArticle()">Voir tout les articles
            </button>
            <!-- bouton retour aux articles -->
            <button
                aria-label="Vior tout les commentaires"
                type="button"
                class="button one btn btn-warning mb-2"
                @click.prevent="postReturn()">
                Voir tout les Commentaires
            </button>
            <!-- Supprimer mon profil -->
            <button
                aria-label="Voir tout les utilisateurs"
                type="submit"
                class="button  btn btn-danger mb-1"
                @click="goUser()">
                Voir les Users
            </button>
             <!-- bouton créer un article -->   
            <button 
                aria-label="Ouvre la fenetre de redaction d'un article"
                type="submit" 
                class="btn btn-success mb-4 mt-2" 
                @click="createPost()">
                Créer un article
            </button>
        </div>
        <!-- tout les comments postés -->
        <div v-if="modeComment == 'comments'">
            <!-- bouton retour -->
            <button
                aria-label="Retour à l'accueil adminitrateur"
                type="submit"
                class="button  btn btn-warning m-3"
                @click="annulArticle()">RETOUR
            </button>
            <!-- cadre chaques comment avec article  -->
            <section class=" postCard mb-4" :key="index" v-for="(comments, index) in comment">
                <div class="date">
                    <p>Envoyer le : {{comments.datePost}}</p>
                </div>
                <div class=" postCard  mb-4">
                    <!-- cadre article -->
                    <div class=" article">
                        <h3>{{comments.title}}</h3>
                        <div class="imgMedia mt-4">
                            <img :src="comments.media_url" alt="media">
                        </div> 
                        <h4>{{comments.description}}</h4> 
                        <!-- <h6>COMMENTS : {{comments}}</h6> -->
                    </div>
                </div>
                <div class=" mb-4">
                    <!-- cadre commentaire -->
                    <div>
                        <div class="date">
                            <p>Envoyé le : {{comments.dateComment}}</p>
                        </div>
                        <div class=" postCard">
                            <div class=" userinuse ">
                                <div class="userAvatar">
                                    <img :src="comments.avatar_url" alt="avatar">
                                </div>
                                    <h3 class=" pseudo mt-3">{{comments.pseudo}}</h3>
                            </div>
                            <div class="postCard">
                                <h3>{{comments.comment}}</h3>
                            <!-- <h3>{{comments}}</h3> -->
                            </div>
                            <button
                                aria-label="Supprime le commentaire"
                                type="submit"
                                class="button  btn btn-danger m-3"
                                @click="supComment(comments.idComment)">Supprimer 
                            </button>
                            <!-- bouton RETOUR -->
                            <button
                                aria-label="Retour à l'accueil administrateur"
                                type="submit"
                                class="button  btn btn-warning m-3"
                                @click="annulArticle()">Retour
                            </button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <!-- tout les articles postés -->
        <section v-if="modeArticle == 'articles'">
            <!-- bouton retour -->
            <button
                aria-label="Retour à l'accueil administrateur"
                type="submit"
                class="button  btn btn-warning m-3"
                @click="annulArticle()">RETOUR
            </button>
            <!-- cadre chaques articles -->
            <section class="  " :key="index" v-for="(posts, index) in post">
                <div class="createPost mb-2">
                    <div class="date mt-2">
                        <p>créé le : {{ posts.date}}</p>
                    </div>
                    <div class="colorCadrePost ">
                        <div class=" userinuse">
                            <div class=" userAvatar">
                                <img :src="posts.avatar_url" alt="avatar">
                            </div>
                            <h3 class="pseudo mt-3">{{ posts.pseudo}}</h3>
                        </div>
                        <div class="imgMedia">
                            <h3 class="mb-3 mt-3"><strong>{{posts.title}}</strong></h3>
                            <div class="imgMedia">
                                <img :src="posts.media_url" alt="media">
                            </div>
                            <h4 class="mt-3">{{ posts.description}}</h4>
                        </div>
                    </div>
                </div>
                <!-- bouton Go sur ce post -->
                <button
                    aria-label="Voir cet article"
                    type="submit"
                    class="button  btn btn-warning m-3"
                    @click="goPost(posts.postID)">Voir ce post
                </button>
                <!-- bouton RETOUR -->
                <button
                    aria-label="Retour à l'accueil administrateur"
                    type="submit"
                    class="button  btn btn-warning m-3"
                    @click="annulArticle()">RETOUR
                </button>
            </section>
        </section>
         
         <!-- cadre chaques USER -->
        <div v-if="modeUser == 'Users'">
            <!-- bouton retour -->
            <button
                aria-label="Retour à l'accueil administrateur"
                type="submit"
                class="button  btn btn-warning m-3"
                @click="annulArticle()">RETOUR
            </button>
            <section class=" card__title postCard mb-4" :key="index" v-for="(UserAlls, index) in UserAll">
                <div class="date">
                    <p>Créé le : {{ UserAlls.date }}</p> 
                </div> 
                <div class=" userinuse ">
                    <div class="userAvatar">
                        <img :src="UserAlls.avatar_url" alt="avatar">
                    </div>
                    <h3 class=" pseudo mt-3">{{ UserAlls.pseudo }}</h3>
                </div> 
                <div class=" colorCadrePost mt-3">
                    <div class="mt-2">
                        <h6>Email :<strong>{{ UserAlls.email }}</strong></h6>
                    </div>
                </div>
                <!-- bouton Suprimé le post -->
                <button
                    aria-label="Supprimer le profil de l'utilisateur"
                    type="submit"
                    class="button  btn btn-danger m-3"
                    @click="supUser(UserAlls.id)">Suprimé le USER
                </button>
                <!-- bouton RETOUR -->
                <button
                    aria-label="Retour à l'accueil administrateur"
                    type="submit"
                    class="button  btn btn-warning m-3"
                    @click="annulArticle()">RETOUR
                </button>
               
            </section> 
   
   
        </div>
    </div>
   
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
    name: "superUser",
    data() {
        return {
            userInfo: "",
            user: [],
            newUser: [],
            post: [],
            comment: [],
            UserAll: [],
            modeArticle: "",
            modeComment: "",
            modeProfil: "",
            modeUser: "",
            modePost: "",
            avatarModif: "",
            btnActif: "btnActif" ,
            token: "",
            id: "",
            myComment: "",
            title: "",
            imageUrl :"",
            image: null
        }
    },
    components: {
        navSuperUser
    },
    mounted(){
        const userInfo = JSON.parse(localStorage.getItem('userInfo'));
        if (userInfo) { 
            this.userInfo = JSON.parse(localStorage.getItem('userInfo'));
            this.id = userInfo.id;
            this.token = userInfo.token;
            this.profil();
            this.articles();
            this.AllUser();
            this.comments();
        } else {
             this.$router.push({ name: "to404" });
        }
    },
    methods : {
        // MODIF display vers créer un post //  
        createPost(){
        this.modePost = 'createPost'
        },
        // PUSH sur la page superUserComments
        goPost(a){ 
            console.log(a);
            localStorage.setItem("postInfo", JSON.stringify(a));
            this.$router.push({ name: "superUserComments" });
        },
        // modif display voir les articles
        goArticle(){
            this.btnActif = "inactif";
            this.modeArticle = "articles";
        },
        // modif display voir les users
        goUser(){
            this.btnActif = "inactif";
            this.modeUser = "Users";
        },
        // retour a la page posts
        postReturn() {
            this.btnActif = "inactif";
            this.modeComment = "comments"
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
        // GET tout les users // postsRoute userAll()
        async AllUser() {
            await axios.get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/users` , {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
                })
                .then((response )=> { 
                console.log("la reponse users : ", response.data);
                // this.UserAll = response.data;
                    for (let l = 0; l < response.data.length; l++) {
                        this.UserAll.push({
                            id: response.data[l].id,
                            pseudo_user: response.data[l].pseudo,
                            email: response.data[l].email,
                            pseudo: response.data[l].pseudo,
                            avatar_url: response.data[l].avatar_url,
                            date: dayjs(response.data[l].date_post).format('ddd D MMM YYYY [à] H[h]mm ')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
                        })
                    }
                })
        },
        // DELETE le user
        supUser(a){
            if (window.confirm( "voulez-vous vraiment supprimer cet USER \n" + 
                  "OK pou supprimer ")) 
            {
                axios.delete(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/users/${a}` , {
                    headers: {
                        'Authorization': `Bearer ${this.userInfo.token}`
                    }
                })
                .then((response )=> { 
                    console.log(response)
                    if (response.status == 200) { 
                    alert("le User a été supprimé..  "); 
                    console.log("le User a été supprimé..  ");
                    location.reload()
                    }               
                }) 
                .catch((error) => {
                    console.log(error);
                })
            } else {
               location.reload();
            }
        },
        // GET tout les articles// postUserIdCtrl()
        async articles(){
            // console.log(this.userInfo.id)
            await axios.get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/posts` , {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
                })
                .then((response )=> { 
                console.log("la reponse article : ", response.data);
                for (let i = 0; i < response.data.length; i++) {
                    this.post.push({
                        id: response.data[i].userId,
                        postID: response.data[i].post_id,
                        avatar_url: response.data[i].avatar_url,
                        pseudo: response.data[i].pseudo,
                        title: JSON.parse(response.data[i].title),
                        description: JSON.parse(response.data[i].description),
                        media_url: response.data[i].media_url,
                        date: dayjs(response.data[i].date_post).format('ddd D MMM YYYY [à] H[h]mm ')  //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
                    })
                // this.post = response.data;
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
        // GET sur tout les comments // 
        async comments(){
            // console.log(this.userInfo.id);
            await axios.get(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/comments` , {
                headers: {
                    'Authorization': `Bearer ${this.userInfo.token}`
                }
            })
            .then((reponse )=> { 
            console.log("la reponse Comment : ", reponse.data);
            // this.comment = reponse.data;
                for (let m = 0; m < reponse.data.length; m++) {
                    this.comment.push({
                        idComment: reponse.data[m].idComment,
                        pseudo: reponse.data[m].pseudo,
                        comment: reponse.data[m].comment,
                        media_url: reponse.data[m].media_url,
                        avatar_url: reponse.data[m].avatar_url,
                        description: JSON.parse(reponse.data[m].description),
                        title: JSON.parse(reponse.data[m].title),
                        dateComment: dayjs(reponse.data[m].dateComment).format('ddd D MMM YYYY [à] H[h]mm '), 
                        datePost: dayjs(reponse.data[m].datePost).format('ddd D MMM YYYY [à] H[h]mm ') //dayjs(res.data[i].date_post).format('L')  //res.data[i].date_post
                    })
                }
            })
            .catch((error) => {
                console.log(error);
            })
        },
        // DELETE un comment
        supComment(a){
            // console.log(a);
            if (window.confirm( "Voulez-vous vraiment supprimer ce commentaire \n" + 
                  "OK pour supprimer")) 
            {
                axios.delete(`${PROTOCOLE.PROTOCOLE}://${PROTOCOLE.SERVER}/post/comment/${a}` , {
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
                    console.log(error);
                })
            } else {
              location.reload()
            }
            
        },
        // charge l'image
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
        // POST un article  
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
        // annule l'article en cours d'ecriture
        annulPost(){
            this.modePost = ''
        },
        // 
        boutonFile() {
        this.$refs.inputFile.click()
        }
       
    }
}
</script>

<style scoped>

</style>