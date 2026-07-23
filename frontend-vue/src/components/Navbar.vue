<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { RouterLink, useRouter } from 'vue-router';
import api from '@/services/api';
import { useAuthStore } from '@/stores/auth';
import '@/assets/styles/components/Navbar.css';

const router = useRouter();
const auth = useAuthStore();
const cartItems = ref([]);
const cartTotal = ref(0);
let intervalId = null;

const handleLogout = () => {
  auth.logout();
  router.push('/');
};

const fetchCart = async () => {
  if (!auth.isAuthenticated) return;
  try {
    const { data } = await api.get('/cart');
    cartItems.value = data;
    cartTotal.value = data.reduce((sum, item) => sum + parseFloat(item.price) * parseInt(item.quantity, 10), 0);
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error fetching cart:', error);
  }
};

const startPolling = () => {
  fetchCart();
  intervalId = setInterval(fetchCart, 3000);
  window.addEventListener('cartUpdated', fetchCart);
};

const stopPolling = () => {
  if (intervalId) {
    clearInterval(intervalId);
    intervalId = null;
  }
  window.removeEventListener('cartUpdated', fetchCart);
  cartItems.value = [];
  cartTotal.value = 0;
};

onMounted(() => {
  if (auth.isAuthenticated) {
    startPolling();
  }
});

watch(
  () => auth.isAuthenticated,
  (isAuth) => {
    if (isAuth) {
      startPolling();
    } else {
      stopPolling();
    }
  }
);

onBeforeUnmount(() => {
  stopPolling();
});

const cartItemCount = computed(() =>
  cartItems.value.reduce((sum, item) => sum + parseInt(item.quantity, 10), 0)
);
</script>

<template>
  <nav class="navbar">
    <div class="navbar-container">
      <div class="navbar-left">
        <RouterLink to="/" class="navbar-brand">HOME</RouterLink>
        <RouterLink to="/products" class="navbar-link">PRODUCTS</RouterLink>
        <RouterLink v-if="auth.isAuthenticated" to="/cart" class="navbar-link cart-link">
          <span>CART</span>
          <template v-if="cartItemCount > 0">
            <span class="cart-badge">{{ cartItemCount }}</span>
            <span class="cart-total">${{ cartTotal.toFixed(2) }}</span>
          </template>
        </RouterLink>
        <template v-if="auth.isAdmin">
          <RouterLink to="/admin/products" class="navbar-link">Manage Product</RouterLink>
          <RouterLink to="/admin/users" class="navbar-link">Admin View</RouterLink>
        </template>
      </div>
      <div class="navbar-right">
        <template v-if="!auth.isAuthenticated">
          <RouterLink to="/register" class="navbar-link">Registry</RouterLink>
          <RouterLink to="/login" class="navbar-link">Login</RouterLink>
        </template>
        <template v-else>
          <span class="navbar-user">{{ auth.user?.nickname }}</span>
          <button type="button" class="navbar-link btn-link" @click="handleLogout">Logout</button>
        </template>
      </div>
    </div>
  </nav>
</template>
