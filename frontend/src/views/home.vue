<template>
  <div class="container mt-4">
    <navHome></navHome>
    <div class="d-flex p-2 bd-highlight justify-content-center">
      <div class="card" style="width: 18rem;">
        <img src="../images/72637191-groupe-de-personnes-avec-illustration-de-téléphones-cellulaires.jpg" class="card-img-top" alt="personnage en groupe échangeant avec leurs telephones ">
        <div class="card-body">
          <h1 class="card-title title">Social-Groupomania</h1>
          <p class="card-text"> <strong>Échangez</strong> avec vos <strong>collegues</strong> des images, gifs ... et autres à venir<br/>
          Un sujet..  votre propre commentaire... <br/>
           Et <strong>échangez</strong> avec eux sur ce <strong>sujet</strong> en repondant à leur propre <strong>commentaires </strong><br/>
           ENJOY
          </p>
          
          <div class="btn btn-primary" aria-label="accéder à la page de Login" @click="goLogin()"><strong>ENTRÉE</strong></div>
        </div>
      </div> 
    </div>
  </div>
   <router-view/>
</template>

<script>

import navHome from '../components/navHome.vue'

export default {
  name: "home",
  data() {
    return {
    };
  },
  components: {
   navHome
  },
  methods: {
    goLogin() {
      this.$router.push({ name: "login" })
    } 
  },
};
</script>


<style scoped>

</style>
