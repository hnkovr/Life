import { defineStore } from 'pinia'
import { login as apiLogin, register as apiRegister, logout as apiLogout } from '../services/auth.service'

interface State {
  access: string | null
  refresh: string | null
}

export const useAuthStore = defineStore('auth', {
  state: (): State => ({
    access: localStorage.getItem('access'),
    refresh: localStorage.getItem('refresh'),
  }),
  getters: {
    isAuthenticated: (s) => Boolean(s.access),
  },
  actions: {
    async register(email: string, password: string, username?: string) {
      await apiRegister({ email, password, username })
    },
    async login(email: string, password: string) {
      const { data } = await apiLogin({ email, password })
      this.access = data.access
      this.refresh = data.refresh
      localStorage.setItem('access', data.access)
      localStorage.setItem('refresh', data.refresh)
    },
    async logout() {
      await apiLogout()
      this.access = null
      this.refresh = null
    },
  },
})

