<script setup>
import { computed, onMounted, ref, watch } from 'vue';
import { RouterLink, useRouter } from 'vue-router';
import api from '@/services/api';
import { useAuthStore } from '@/stores/auth';
import '@/assets/styles/pages/Cart.css';

const auth = useAuthStore();
const router = useRouter();
const cartItems = ref([]);
const loading = ref(true);
const processing = ref(false);

const fetchCart = async () => {
  if (!auth.isAuthenticated) {
    loading.value = false;
    return;
  }
  try {
    const { data } = await api.get('/cart');
    cartItems.value = data;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error fetching cart:', error);
  } finally {
    loading.value = false;
  }
};

const updateQuantity = async (cartItemId, newQuantity) => {
  try {
    await api.put(`/cart/${cartItemId}`, { quantity: newQuantity });
    fetchCart();
    window.dispatchEvent(new Event('cartUpdated'));
  } catch (error) {
    alert(error.response?.data?.message || 'Error updating cart');
  }
};

const removeItem = async (cartItemId) => {
  try {
    await api.delete(`/cart/${cartItemId}`);
    fetchCart();
    window.dispatchEvent(new Event('cartUpdated'));
  } catch (error) {
    alert(error.response?.data?.message || 'Error removing item');
  }
};

const calculateTotal = computed(() =>
  cartItems.value.reduce((total, item) => total + parseFloat(item.price) * parseInt(item.quantity, 10), 0)
);

const handleCheckout = async () => {
  if (cartItems.value.length === 0) {
    alert('Your cart is empty');
    return;
  }

  if (!window.confirm(`Confirm order for $${calculateTotal.value.toFixed(2)}?`)) {
    return;
  }

  processing.value = true;
  try {
    await api.post('/orders');
    alert('Order placed successfully!');
    cartItems.value = [];
    window.dispatchEvent(new Event('cartUpdated'));
    router.push('/products');
  } catch (error) {
    alert(error.response?.data?.message || 'Error placing order');
  } finally {
    processing.value = false;
  }
};

onMounted(() => {
  fetchCart();
});

watch(
  () => auth.isAuthenticated,
  (isAuth) => {
    if (isAuth) {
      fetchCart();
    } else {
      cartItems.value = [];
    }
  }
);
</script>

<template>
  <div v-if="loading" class="loading">Loading cart...</div>
  <div v-else class="cart-container">
    <h1>My Cart</h1>
    <div v-if="cartItems.length === 0" class="cart-empty">
      <div class="cart-empty-message">Your cart is empty</div>
      <RouterLink to="/products" class="btn-primary" style="max-width: 250px; margin: 0 auto;">
        Browse Products
      </RouterLink>
    </div>
    <template v-else>
      <div class="cart-table" style="margin-top: 30px;">
        <table>
          <thead>
            <tr>
              <th>Item</th>
              <th>Price</th>
              <th>Quantity</th>
              <th>Total</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in cartItems" :key="item.id">
              <td>
                <div class="cart-item-info">
                  <img :src="item.image_url || 'https://via.placeholder.com/80x80'" :alt="item.name" class="cart-item-image" />
                  <div>
                    <div class="cart-item-name">{{ item.name }}</div>
                    <div v-if="item.selected_color || item.selected_size" class="cart-item-details">
                      <span v-if="item.selected_color">Color: {{ item.selected_color }}</span>
                      <span v-if="item.selected_color && item.selected_size"> • </span>
                      <span v-if="item.selected_size">Size: {{ item.selected_size }}</span>
                    </div>
                  </div>
                </div>
              </td>
              <td class="cart-item-price">${{ parseFloat(item.price).toFixed(2) }}</td>
              <td>
                <div class="quantity-controls">
                  <button type="button" @click="updateQuantity(item.id, item.quantity - 1)">−</button>
                  <span class="quantity-display">{{ item.quantity }}</span>
                  <button type="button" @click="updateQuantity(item.id, item.quantity + 1)">+</button>
                </div>
              </td>
              <td class="cart-item-total">${{ (parseFloat(item.price) * parseInt(item.quantity, 10)).toFixed(2) }}</td>
              <td>
                <button type="button" class="btn-danger" @click="removeItem(item.id)">×</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="cart-summary">
        <h3>Total: ${{ calculateTotal.toFixed(2) }}</h3>
        <button type="button" class="btn-primary" :disabled="processing || cartItems.length === 0" @click="handleCheckout">
          {{ processing ? 'Processing...' : 'Place Order' }}
        </button>
      </div>
    </template>
  </div>
</template>
