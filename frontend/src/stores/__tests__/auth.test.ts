import { setActivePinia, createPinia } from 'pinia'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { useAuthStore } from '../../stores/auth'
import * as authApi from '../../services/auth.service'

describe('auth store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    vi.restoreAllMocks()
    localStorage.clear()
  })

  it('logs in and stores tokens', async () => {
    vi.spyOn(authApi, 'login').mockResolvedValue({ data: { access: 'a1', refresh: 'r1' } } as any)
    const store = useAuthStore()
    await store.login('u@example.com', 'pass')
    expect(store.access).toBe('a1')
    expect(store.refresh).toBe('r1')
    expect(localStorage.getItem('access')).toBe('a1')
  })
})

