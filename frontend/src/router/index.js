import { createRouter, createWebHashHistory } from 'vue-router'
import postCommentaires from '../views/postCommentaires.vue'
import posts from '../views/posts.vue'
import profil from '../views/profil.vue'
import login from '../views/login.vue'
import superUser from '../views/superUser.vue'
import superUserComments from '../views/superUserComments.vue'
import home from '../views/home.vue'
import to404 from '../views/404.vue'

const routes = [
  {
    path: '/:pathMatch(.*)*',
    name: 'to404',
    component: to404
  },
  {
    path: '/',
    name: 'home',
    component: home
  },
  {
    path: '/superUserComments',
    name: 'superUserComments',
    component: superUserComments
  },
  {
    path: '/superUser',
    name: 'superUser',
    component: superUser
  },
  
  {
    path: '/postCommentaires',
    name: 'postCommentaires',
    component: postCommentaires
  },
  {
    path: '/posts',
    name: 'posts',
    component: posts
  },
  {
    path: '/profil',
    name: 'profil',
    component: profil
  },
  {
    path: '/login',
    name: 'login',
    component: login
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
