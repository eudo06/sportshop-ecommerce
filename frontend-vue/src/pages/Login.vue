<script setup>
import { ref } from 'vue';
import { RouterLink, useRoute, useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import '@/assets/styles/pages/Login.css';

const email = ref('');
const password = ref('');
const error = ref('');
const loading = ref(false);
const auth = useAuthStore();
const router = useRouter();
const route = useRoute();

const handleSubmit = async (event) => {
  event.preventDefault();
  error.value = '';
  loading.value = true;

  const result = await auth.login(email.value, password.value);
  loading.value = false;

  if (result.success) {
    const redirect = route.query.redirect || '/products';
    router.push(redirect);
  } else {
    error.value = result.message;
  }
};
</script>

<template>
  <div class="login-container">
    <div class="form-container">
      <h2>Login</h2>
      <div v-if="error" class="message error">{{ error }}</div>
      <form @submit="handleSubmit">
        <div class="form-group">
          <label>Email</label>
          <input v-model="email" type="email" required />
        </div>
        <div class="form-group">
          <label>Password</label>
          <input v-model="password" type="password" required />
        </div>
        <button type="submit" class="btn-primary" :disabled="loading">
          {{ loading ? 'Logging in...' : 'Login' }}
        </button>
      </form>
      <p style="margin-top: 20px; text-align: center;">
        Don't have an account? <RouterLink to="/register">Sign Up</RouterLink>
      </p>
    </div>
  </div>
</template>
