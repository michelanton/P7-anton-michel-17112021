<template>
  <div>
    <nav>
      <div id="logo">
        <img class="logo" @click="goHome()" alt="logo de Groupomania logo" src="../assets/logo.png">
      </div>
      <ul>
        <li class="card__action" @click="goProfil()">Profil</li>
        <li class="card__action" @click="disconnection()">Déconnexion</li> 
      </ul>
    </nav>
  </div>
  <router-view/>
</template>

<script>
export default {
    name: "navGeneral",
    data() {
      return {

      }
    
  },
  methods: {
    goHome() {
      localStorage.clear();
      this.$router.push({ name: 'home' });
    },
    goProfil() {
      this.$router.push({ name: 'profil' });
    } ,
    disconnection() {
      if (window.confirm( "Voulez-vous vraiment vous déconnecter ?" )) {
          localStorage.clear();
          this.$router.push({ name: 'login' });
      }
    },
  }
}
</script>

<style >
.logo:hover {
  cursor: pointer;
}
.logo {
  margin: 0px auto 0px auto ;
}
nav {
background-color: #9fd4f3 ;
padding : 10px
}
nav {
background-color: #9fd4f3 ;
padding : 10px
}
nav ul {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-around;
  align-items: center;
}
nav li {
  list-style: none;
  margin: 10px auto 10px auto ;
  color: #7e06a3;
  font-size: 22px;
  font-weight: bold;
}
nav li:hover {
  cursor: pointer;
  color: rgb(206, 86, 65);
}

</style>