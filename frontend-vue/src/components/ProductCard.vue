<script setup>
import { computed } from 'vue';
import { RouterLink, useRouter } from 'vue-router';
import api from '@/services/api';
import { useAuthStore } from '@/stores/auth';

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
});

const emit = defineEmits(['added']);
const auth = useAuthStore();
const router = useRouter();

const discount = computed(() => parseInt(props.product.discount_percentage, 10) || 0);
const currentPrice = computed(() => parseFloat(props.product.price) || 0);
const originalPrice = computed(() => (props.product.original_price ? parseFloat(props.product.original_price) : currentPrice.value));
const averageRating = computed(() => parseFloat(props.product.average_rating) || 0);
const fullStars = computed(() => Math.floor(averageRating.value));
const hasHalfStar = computed(() => averageRating.value % 1 >= 0.5);

const handleAddToCart = async () => {
  if (!auth.isAuthenticated) {
    alert('You must be logged in to add to cart');
    router.push('/login');
    return;
  }

  const hasColors = props.product.available_colors && props.product.available_colors.trim().length > 0;
  const hasSizes = props.product.available_sizes && props.product.available_sizes.trim().length > 0;

  if (hasColors || hasSizes) {
    router.push(`/products/${props.product.id}`);
    return;
  }

  try {
    await api.post('/cart', { productId: props.product.id, quantity: 1 });
    window.dispatchEvent(new Event('cartUpdated'));
    emit('added');
    alert('Product added to cart!');
  } catch (error) {
    alert(error.response?.data?.message || 'Error adding to cart');
  }
};
</script>

<template>
  <div class="product-card">
    <div v-if="discount > 0" class="product-badge">{{ discount }}% Off</div>
    <RouterLink :to="`/products/${product.id}`">
      <img
        :src="product.image_url || 'https://via.placeholder.com/300x200'"
        :alt="product.name"
        class="product-image"
      />
    </RouterLink>
    <div class="product-info">
      <div class="product-rating">
        <span
          v-for="index in 5"
          :key="index"
          :class="['star', index > fullStars + (hasHalfStar ? 1 : 0) ? 'empty' : '']"
        >
          {{ index <= fullStars ? '★' : hasHalfStar && index === fullStars + 1 ? '☆' : '☆' }}
        </span>
      </div>
      <RouterLink :to="`/products/${product.id}`" class="product-name">
        {{ product.name }}
      </RouterLink>
      <p v-if="product.description" class="product-description">{{ product.description }}</p>
      <div class="product-price">
        <span v-if="discount > 0" class="price-original">${{ originalPrice.toFixed(2) }}</span>
        <span class="price-current">${{ currentPrice.toFixed(2) }}</span>
      </div>
      <button class="btn-add-cart" :disabled="!auth.isAuthenticated" @click="handleAddToCart">
        ADD TO CART
      </button>
    </div>
  </div>
</template>
