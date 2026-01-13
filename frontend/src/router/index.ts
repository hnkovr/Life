import { createRouter, createWebHistory, RouterHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const Login = () => import('../views/Login.vue')
const Register = () => import('../views/Register.vue')
const Tasks = () => import('../views/Tasks.vue')

export function makeRouter(history: RouterHistory = createWebHistory()) {
  const router = createRouter({
    history,
    routes: [
      { path: '/login', name: 'login', component: Login },
      { path: '/register', name: 'register', component: Register },
      { path: '/', name: 'tasks', component: Tasks, meta: { requiresAuth: true } },
    ],
  })

  router.beforeEach((to) => {
    const auth = useAuthStore()
    if (to.meta.requiresAuth && !auth.isAuthenticated) {
      return { name: 'login' }
    }
  })

  return router
}

const router = makeRouter()
export default router
