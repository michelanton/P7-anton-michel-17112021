<template>
  <div>
    <footer>
      <a href="#"><h4>Mentions légales</h4></a>
      <div class="cadreContact">
        <h5>Contact Modérateur : </h5><a href="#">moderateur@groupomania.com</a>
      </div> 
    </footer>
  </div>
</template>

<script>
export default {
    name: "leFouter",
    data() {
      return {

      }
    
  },
  methods: {
    
  }
}
</script>

<style >
footer {
    background-color: #9fd4f3;
    min-height: 100px;
    width: 95%;
    margin: 20px auto;
    padding-bottom: 30px;
    overflow-wrap: break-word;
}
footer h5{
    margin: 10px 0px 10px 10px;
    font-size: 22px;
    color: rgb(182, 34, 34);
}
footer h4{
    margin: 0px 0px 30px 0px;
    font-size: 28px;
    color: rgb(18, 7, 117);
}
footer a {
    font-size: 22px;
    color: rgb(3, 92, 170);
    margin: 5px 0px 10px 10px;
    text-decoration: none;
}
footer a:hover {
    color: rgb(247, 174, 85);
    text-decoration: none;
}
.cadreContact {
    border: 1px solid rgb(2, 32, 58);
    margin: auto 50px;
}
</style>