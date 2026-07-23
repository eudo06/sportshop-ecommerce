<script setup>
import { ref } from 'vue';
import { RouterLink, useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import '@/assets/styles/pages/Register.css';

const nickname = ref('');
const email = ref('');
const password = ref('');
const error = ref('');
const loading = ref(false);
const auth = useAuthStore();
const router = useRouter();

const handleSubmit = async (event) => {
  event.preventDefault();
  error.value = '';
  loading.value = true;

  const result = await auth.register(nickname.value, email.value, password.value);
  loading.value = false;

  if (result.success) {
    router.push('/products');
  } else {
    error.value = result.message;
  }
};
</script>

<template>
  <div class="register-container">
    <div class="form-container">
      <h2>Sign Up</h2>
      <div v-if="error" class="message error">{{ error }}</div>
      <form @submit="handleSubmit">
        <div class="form-group">
          <label>Nickname</label>
          <input v-model="nickname" type="text" required />
        </div>
        <div class="form-group">
          <label>Email</label>
          <input v-model="email" type="email" required />
        </div>
        <div class="form-group">
          <label>Password</label>
          <input v-model="password" type="password" required minlength="6" />
        </div>
        <button type="submit" class="btn-primary" :disabled="loading">
          {{ loading ? 'Signing up...' : 'Sign Up' }}
        </button>
      </form>
      <p style="margin-top: 20px; text-align: center;">
        Already have an account? <RouterLink to="/login">Login</RouterLink>
      </p>
    </div>
  </div>
</template>
