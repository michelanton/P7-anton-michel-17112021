<template>
  <div class="container mt-4">
    <navHome></navHome>
    <div class="oupps mt-5 mb-5">
        <h1 class="title">Oupps!... erreur 404... </h1>
        <h2 class="title"> il fallait prendre à droite aprés le moulin ...! <br/>
          Vous voila perdu en rase campagne du NET...! <br/>
          Cliquez sur le bouton pour revenir à l'acceuil</h2>
        <button type="button" class="btn btn-warning mt-5 mb-2" aria-label="accéder à la page d'accueil" @click=" gohome() ">retour à la page d'acceiul</button>
    </div>
  </div>
   <router-view/>
</template>

<script>

import navHome from '../components/navHome.vue'

export default {
  name: "to404",
  data() {
    return {
    };
  },
  components: {
   navHome
  },
  methods: {
    gohome() {
      this.$router.push({ name: "home" })
    } 
  },
};
</script>


<style scoped>

</style>
