<template>
  <div class="max-w-2xl mx-auto py-10">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-semibold">Мои задачи</h1>
      <button @click="logout" class="text-sm underline">Выйти</button>
    </div>
    <form @submit.prevent="create" class="flex gap-2 mb-6">
      <input v-model="title" placeholder="Новая задача" class="flex-1 border rounded px-3 py-2" />
      <button type="submit" class="bg-black text-white rounded px-4">Добавить</button>
    </form>
    <div class="space-y-2">
      <div v-for="t in tasks" :key="t.id" class="border rounded px-3 py-2 flex items-center justify-between">
        <div>
          <div class="font-medium" :class="{ 'line-through text-gray-500': t.status==='done' }">{{ t.title }}</div>
          <div class="text-xs text-gray-500">{{ t.domain }} • {{ t.status }}</div>
        </div>
        <div class="flex gap-2 text-sm">
          <button @click="complete(t)" :disabled="t.status==='done'" class="underline disabled:opacity-50">Сделано</button>
          <button @click="remove(t)" class="underline text-red-600">Удалить</button>
        </div>
      </div>
    </div>
  </div>
  </template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { createTask, listTasks, completeTask, deleteTask, type Task } from '../services/task.service'

const tasks = ref<Task[]>([])
const title = ref('')
const auth = useAuthStore()
const router = useRouter()

async function load() {
  const { data } = await listTasks()
  tasks.value = data
}

async function create() {
  if (!title.value.trim()) return
  const { data } = await createTask({ title: title.value, domain: 'personal' })
  tasks.value.unshift(data)
  title.value = ''
}

async function complete(t: Task) {
  const { data } = await completeTask(t.id)
  const idx = tasks.value.findIndex((x) => x.id === t.id)
  if (idx >= 0) tasks.value[idx] = data
}

async function remove(t: Task) {
  await deleteTask(t.id)
  tasks.value = tasks.value.filter((x) => x.id !== t.id)
}

async function logout() {
  await auth.logout()
  router.push({ name: 'login' })
}

onMounted(load)
</script>

