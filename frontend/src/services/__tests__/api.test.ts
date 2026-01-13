import { describe, it, expect, vi } from 'vitest'
import api from '../../services/api'
import MockAdapter from 'axios-mock-adapter'

describe('api client', () => {
  it('adds Authorization header when access token exists', async () => {
    const mock = new MockAdapter(api)
    localStorage.setItem('access', 'AAA')
    mock.onGet('/tasks/').reply((config) => {
      expect(config.headers?.Authorization).toBe('Bearer AAA')
      return [200, []]
    })
    const res = await api.get('/tasks/')
    expect(res.status).toBe(200)
  })
})

