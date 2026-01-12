<template>
  <div class="max-w-sm mx-auto py-24">
    <h1 class="text-2xl font-semibold mb-6">Регистрация</h1>
    <form @submit.prevent="onSubmit" class="space-y-4">
      <div>
        <label class="block text-sm mb-1">Email</label>
        <input v-model="email" type="email" class="w-full border rounded px-3 py-2" required />
      </div>
      <div>
        <label class="block text-sm mb-1">Пароль</label>
        <input v-model="password" type="password" class="w-full border rounded px-3 py-2" required />
      </div>
      <button type="submit" class="w-full bg-black text-white rounded py-2">Создать аккаунт</button>
      <p class="text-sm mt-2">Уже есть аккаунт? <router-link to="/login" class="underline">Войти</router-link></p>
      <p v-if="error" class="text-red-600 text-sm mt-2">{{ error }}</p>
    </form>
  </div>
  </template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const email = ref('')
const password = ref('')
const error = ref('')
const auth = useAuthStore()
const router = useRouter()

async function onSubmit() {
  error.value = ''
  try {
    await auth.register(email.value, password.value)
    await auth.login(email.value, password.value)
    router.push({ name: 'tasks' })
  } catch (e) {
    error.value = 'Не удалось создать аккаунт'
  }
}
</script>

