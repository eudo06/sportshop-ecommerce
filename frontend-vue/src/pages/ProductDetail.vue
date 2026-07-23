<script setup>
import { computed, onMounted, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '@/services/api';
import { useAuthStore } from '@/stores/auth';
import '@/assets/styles/pages/ProductDetail.css';

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();

const product = ref(null);
const loading = ref(true);
const userRating = ref(0);
const hoveredStar = ref(0);
const selectedColor = ref(null);
const selectedSize = ref(null);

const discount = computed(() => parseInt(product.value?.discount_percentage, 10) || 0);
const currentPrice = computed(() => (product.value?.price ? parseFloat(product.value.price) : 0));
const originalPrice = computed(() => (product.value?.original_price ? parseFloat(product.value.original_price) : currentPrice.value));
const averageRating = computed(() => (product.value?.average_rating ? parseFloat(product.value.average_rating) : 0));
const availableColors = computed(() =>
  product.value?.available_colors ? product.value.available_colors.split(',').map((c) => c.trim()) : []
);
const availableSizes = computed(() =>
  product.value?.available_sizes ? product.value.available_sizes.split(',').map((s) => s.trim()) : []
);

const fetchProduct = async () => {
  loading.value = true;
  try {
    const { data } = await api.get(`/products/${route.params.id}`);
    product.value = data;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error fetching product:', error);
  } finally {
    loading.value = false;
  }
};

const fetchUserRating = async () => {
  if (!auth.isAuthenticated) return;
  try {
    const { data } = await api.get(`/ratings/${route.params.id}`);
    if (data.rating) {
      userRating.value = data.rating;
    }
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error fetching rating:', error);
  }
};

const handleAddToCart = async () => {
  if (!auth.isAuthenticated) {
    alert('You must be logged in to add to cart');
    router.push('/login');
    return;
  }

  if (availableColors.value.length > 0 && !selectedColor.value) {
    alert('Please select a color');
    return;
  }

  if (availableSizes.value.length > 0 && !selectedSize.value) {
    alert('Please select a size');
    return;
  }

  try {
    await api.post('/cart', {
      productId: route.params.id,
      quantity: 1,
      selectedColor: selectedColor.value || null,
      selectedSize: selectedSize.value || null
    });
    window.dispatchEvent(new Event('cartUpdated'));
    alert('Product added to cart!');
  } catch (error) {
    alert(error.response?.data?.message || 'Error adding to cart');
  }
};

const handleRate = async (rating) => {
  if (!auth.isAuthenticated) {
    alert('You must be logged in to rate a product');
    return;
  }

  try {
    await api.post(`/ratings/${route.params.id}`, { rating });
    userRating.value = rating;
    fetchProduct();
  } catch (error) {
    alert(error.response?.data?.message || 'Error rating product');
  }
};

const displayStars = computed(() => hoveredStar.value || userRating.value);

const getColorCode = (colorName) => {
  const colorMap = {
    black: '#000000',
    white: '#FFFFFF',
    blue: '#0066CC',
    red: '#DC143C',
    green: '#228B22',
    yellow: '#FFD700',
    orange: '#FF8C00',
    pink: '#FF69B4',
    rose: '#FF69B4',
    purple: '#9370DB',
    gray: '#808080',
    grey: '#808080',
    gris: '#808080',
    'bleu ciel': '#87CEEB',
    'sky blue': '#87CEEB',
    brown: '#8B4513',
    navy: '#000080',
    cyan: '#00CED1',
    lime: '#32CD32',
    maroon: '#800000',
    olive: '#808000',
    teal: '#008080',
    silver: '#C0C0C0',
    gold: '#FFD700'
  };
  return colorMap[colorName.toLowerCase()] || '#CCCCCC';
};

watch(
  () => route.params.id,
  () => {
    fetchProduct();
    if (auth.isAuthenticated) {
      fetchUserRating();
    }
  }
);

watch(
  () => auth.isAuthenticated,
  (isAuth) => {
    if (isAuth) {
      fetchUserRating();
    } else {
      userRating.value = 0;
    }
  }
);

onMounted(() => {
  fetchProduct();
  if (auth.isAuthenticated) {
    fetchUserRating();
  }
});
</script>

<template>
  <div v-if="loading" class="loading">Loading...</div>
  <div v-else-if="!product" class="loading">Product not found</div>
  <div v-else class="product-detail-container">
    <div class="product-detail">
      <div class="product-detail-image">
        <img :src="product.image_url || 'https://via.placeholder.com/500x500'" :alt="product.name" />
        <div v-if="discount > 0" class="product-badge">{{ discount }}% Off</div>
      </div>
      <div class="product-detail-info">
        <h1>{{ product.name }}</h1>
        <div class="product-rating">
          <span v-for="index in 5" :key="index" :class="['star', index <= Math.floor(averageRating) ? '' : 'empty']">
            {{ index <= Math.floor(averageRating) ? '★' : '☆' }}
          </span>
          <span style="margin-left: 10px">({{ product.rating_count || 0 }} reviews)</span>
        </div>

        <div v-if="auth.isAuthenticated" class="user-rating">
          <p>Your Rating:</p>
          <div class="product-rating">
            <span
              v-for="index in 5"
              :key="index"
              class="star"
              :class="{ empty: index > displayStars }"
              style="cursor: pointer"
              @click="handleRate(index)"
              @mouseenter="hoveredStar = index"
              @mouseleave="hoveredStar = 0"
            >
              {{ index <= displayStars ? '★' : '☆' }}
            </span>
          </div>
        </div>

        <p class="product-description-full">{{ product.description || 'No description available' }}</p>
        <div class="product-price">
          <span v-if="discount > 0" class="price-original">${{ originalPrice.toFixed(2) }}</span>
          <span class="price-current">${{ currentPrice.toFixed(2) }}</span>
        </div>

        <div v-if="availableColors.length" class="color-selector">
          <label class="color-selector-label">Color:</label>
          <div class="color-options">
            <button
              v-for="color in availableColors"
              :key="color"
              type="button"
              class="color-option"
              :class="{ selected: selectedColor === color }"
              :title="color"
              @click="selectedColor = color"
            >
              <div class="color-circle" :style="{ backgroundColor: getColorCode(color) }" />
              <span class="color-name">{{ color }}</span>
            </button>
          </div>
        </div>

        <div v-if="availableSizes.length" class="size-selector">
          <label class="size-selector-label">Size:</label>
          <div class="size-options">
            <button
              v-for="size in availableSizes"
              :key="size"
              type="button"
              class="size-option"
              :class="{ selected: selectedSize === size }"
              @click="selectedSize = size"
            >
              {{ size }}
            </button>
          </div>
        </div>

        <button class="btn-add-cart" :disabled="!auth.isAuthenticated" @click="handleAddToCart">
          ADD TO CART
        </button>
      </div>
    </div>
  </div>
</template>
