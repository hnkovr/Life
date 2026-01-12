import api from './api'

export async function register(payload: { email: string; password: string; username?: string }) {
  return api.post('/auth/register', payload)
}

export async function login(payload: { email: string; password: string }) {
  return api.post('/auth/login', payload)
}

export async function logout() {
  localStorage.removeItem('access')
  localStorage.removeItem('refresh')
}

