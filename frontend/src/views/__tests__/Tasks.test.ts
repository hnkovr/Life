import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { mount } from '@vue/test-utils'
import Tasks from '../Tasks.vue'
import * as taskApi from '../../services/task.service'

describe('Tasks view', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
    localStorage.setItem('access', 'token')
  })

  it('loads tasks and can create', async () => {
    vi.spyOn(taskApi, 'listTasks').mockResolvedValue({ data: [] } as any)
    vi.spyOn(taskApi, 'createTask').mockResolvedValue({
      data: { id: '1', title: 'A', status: 'todo', domain: 'personal', created_at: '', updated_at: '' },
    } as any)
    const wrapper = mount(Tasks)
    await wrapper.find('input').setValue('A')
    await wrapper.find('form').trigger('submit.prevent')
    expect(wrapper.text()).toContain('Мои задачи')
  })
})

