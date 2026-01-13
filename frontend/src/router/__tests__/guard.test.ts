import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { createMemoryHistory } from 'vue-router'
import { makeRouter } from '../index'
import { useAuthStore } from '../../stores/auth'

describe('router guard', () => {
  let router: ReturnType<typeof makeRouter>
  beforeEach(() => {
    setActivePinia(createPinia())
    router = makeRouter(createMemoryHistory())
  })

  it('redirects to login when unauthenticated', async () => {
    const auth = useAuthStore()
    auth.access = null
    await router.push('/')
    expect(router.currentRoute.value.name).toBe('login')
  })

  it('allows access when authenticated', async () => {
    const auth = useAuthStore()
    auth.access = 'token'
    await router.push('/')
    expect(router.currentRoute.value.name).toBe('tasks')
})
})
