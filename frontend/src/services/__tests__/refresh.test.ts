import { describe, it, expect } from 'vitest'
import api from '../../services/api'
import MockAdapter from 'axios-mock-adapter'

describe('api refresh interceptor', () => {
  it('refreshes token on 401 and retries once', async () => {
    const mock = new MockAdapter(api)
    localStorage.setItem('access', 'expired')
    localStorage.setItem('refresh', 'refresh1')

    // First call returns 401
    mock.onGet('/tasks/').replyOnce(401)
    // Refresh endpoint returns new access
    mock.onPost('/auth/refresh').reply(200, { access: 'newA' })
    // Retried call succeeds
    mock.onGet('/tasks/').reply(200, [])

    const res = await api.get('/tasks/')
    expect(res.status).toBe(200)
    expect(localStorage.getItem('access')).toBe('newA')
  })
})

