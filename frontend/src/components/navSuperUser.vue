<template>
  <div>
    <nav>
      <div class="logo">
        <img class="logo" @click="goHome()" alt="logo de Groupomania logo" src="../assets/logo.png">
      </div>
        <ul>
          <li class="card__action " @click="disconnection()">Déconnexion</li> 
        </ul>
    </nav>
  </div>
  <router-view/>
</template>

<script>
export default {
    name: "navSuperUser",
    data() {
      return {

      }
    
  },
  methods: {
    goHome() {
      localStorage.clear();
      this.$router.push({ name: 'home' });
    },
    disconnection() {
      if (window.confirm( "Voulez-vous vraiment vous déconnecter ?" )) {
          localStorage.clear();
          this.$router.push({ name: 'login' });
      }
      
    }
  }
}
</script>

<style scope>
/* nav {
background-color: #acb1f8  ;


display: flex;
justify-content: space-between;

}
nav ul {
 
  display: flex;
 flex-wrap: wrap;
  justify-content: space-around;
  align-items: center;
  margin: auto 10px;
 
}
nav li {
  list-style: none;
  margin: auto 15px;
}
nav li a {
  font-weight: bold;
  color: #dbec3d;
  text-decoration: none;
}
nav li a:hover {
  color: rgb(206, 86, 65);
  text-decoration: none;
}

.appel {
  color: #dbec3d;
}
.appel:hover {
  cursor: pointer;
  color: rgb(206, 86, 65);
} */

</style>