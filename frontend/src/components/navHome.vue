<template>
  <div>
    <nav>
      <div id="logo">
        <img alt="logo de Groupomania logo" src="../assets/logo.png">
      </div>
    </nav>
  </div>
  <router-view/>
</template>

<script>
export default {
    name: "navHome",
    data() {
      return {

      }
    
  },
}
</script>

<style>
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