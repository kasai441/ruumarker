import { createRouter, createWebHistory } from 'vue-router'
import ImageEdit from '../components/image_edit.vue'

const routes = [
  {
    path: '/image/edit',
    name: 'image_edit',
    component: ImageEdit
  },
  {
    path: '/image/show',
    name: 'image_show',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../components/image_show.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
