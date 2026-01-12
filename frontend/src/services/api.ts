import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api',
})

api.interceptors.request.use((config) => {
  const access = localStorage.getItem('access')
  if (access) {
    config.headers = config.headers || {}
    config.headers.Authorization = `Bearer ${access}`
  }
  return config
})

api.interceptors.response.use(
  (r) => r,
  async (error) => {
    const original = error.config
    if (error.response?.status === 401 && !original.__isRetry) {
      const refresh = localStorage.getItem('refresh')
      if (refresh) {
        try {
          const res = await api.post('/auth/refresh', { refresh })
          localStorage.setItem('access', res.data.access)
          original.headers = original.headers || {}
          original.headers.Authorization = `Bearer ${res.data.access}`
          original.__isRetry = true
          return api(original)
        } catch (_) {
          // fallthrough to reject
        }
      }
    }
    return Promise.reject(error)
  },
)

export default api

