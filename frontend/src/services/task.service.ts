import api from './api'

export interface Task {
  id: string
  title: string
  description?: string
  status: 'todo' | 'doing' | 'waiting' | 'done' | 'canceled'
  domain: 'work' | 'personal'
  due_date?: string | null
  completed_at?: string | null
  created_at: string
  updated_at: string
}

export async function listTasks(params?: Record<string, string>) {
  return api.get<Task[]>('/tasks/', { params })
}

export async function createTask(payload: Partial<Task>) {
  return api.post<Task>('/tasks/', payload)
}

export async function updateTask(id: string, payload: Partial<Task>) {
  return api.patch<Task>(`/tasks/${id}/`, payload)
}

export async function deleteTask(id: string) {
  return api.delete(`/tasks/${id}/`)
}

export async function completeTask(id: string) {
  return api.post<Task>(`/tasks/${id}/complete/`)
}

