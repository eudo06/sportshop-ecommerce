<script setup>
import { onMounted, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import api from '@/services/api';
import ProductCard from '@/components/ProductCard.vue';
import { useAuthStore } from '@/stores/auth';
import '@/assets/styles/pages/ProductList.css';

const auth = useAuthStore();
const route = useRoute();
const products = ref([]);
const categories = ref([]);
const loading = ref(true);
const filters = ref({
  search: '',
  category_id: route.query.category_id || '',
  min_price: '',
  max_price: ''
});

const fetchCategories = async () => {
  try {
    const { data } = await api.get('/categories');
    categories.value = data;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error fetching categories:', error);
  }
};

const fetchProducts = async () => {
  loading.value = true;
  try {
    const params = {};
    if (filters.value.search) params.search = filters.value.search;
    if (filters.value.category_id === 'on_sale') {
      params.on_sale = 'true';
    } else if (filters.value.category_id) {
      params.category_id = filters.value.category_id;
    }
    if (filters.value.min_price) params.min_price = filters.value.min_price;
    if (filters.value.max_price) params.max_price = filters.value.max_price;

    const { data } = await api.get('/products', { params });
    products.value = data;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error fetching products:', error);
  } finally {
    loading.value = false;
  }
};

watch(
  () => route.query.category_id,
  (categoryId) => {
    filters.value = { ...filters.value, category_id: categoryId || '' };
  }
);

watch(
  filters,
  () => {
    fetchProducts();
  },
  { deep: true }
);

onMounted(() => {
  fetchCategories();
  fetchProducts();
});
</script>

<template>
  <div class="product-list-container">
    <h1>Product List</h1>

    <div v-if="auth.isAuthenticated" class="filters-container">
      <div class="filters-row">
        <div class="search-bar">
          <label>Search</label>
          <input type="text" v-model="filters.search" name="search" placeholder="Search for a product..." />
        </div>
        <div class="filter-group">
          <label>Category</label>
          <select v-model="filters.category_id" name="category_id">
            <option value="">All Categories</option>
            <option value="on_sale">On Sale</option>
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
          </select>
        </div>
        <div class="filter-group">
          <label>Min Price</label>
          <input type="number" v-model="filters.min_price" name="min_price" placeholder="0" />
        </div>
        <div class="filter-group">
          <label>Max Price</label>
          <input type="number" v-model="filters.max_price" name="max_price" placeholder="1000" />
        </div>
      </div>
    </div>

    <div v-if="loading" class="loading">Loading products...</div>
    <div v-else-if="products.length === 0" class="loading">No products found</div>
    <div v-else class="products-grid">
      <ProductCard v-for="product in products" :key="product.id" :product="product" />
    </div>
  </div>
</template>
