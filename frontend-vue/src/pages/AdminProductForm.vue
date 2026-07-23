<script setup>
import { computed, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '@/services/api';
import '@/assets/styles/pages/AdminProducts.css';

const route = useRoute();
const router = useRouter();
const categories = ref([]);
const loading = ref(true);
const formData = ref({
  name: '',
  description: '',
  price: '',
  original_price: '',
  category_id: '',
  image_url: '',
  discount_percentage: 0,
  stock: 0,
  available_colors: '',
  available_sizes: ''
});

const isEditMode = computed(() => !!route.params.id);

const fetchCategories = async () => {
  try {
    const { data } = await api.get('/categories');
    categories.value = data;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error:', error);
  }
};

const fetchProduct = async () => {
  try {
    const { data } = await api.get(`/products/${route.params.id}`);
    formData.value = {
      name: data.name || '',
      description: data.description || '',
      price: data.price || '',
      original_price: data.original_price || '',
      category_id: data.category_id || '',
      image_url: data.image_url || '',
      discount_percentage: data.discount_percentage || 0,
      stock: data.stock || 0,
      available_colors: data.available_colors || '',
      available_sizes: data.available_sizes || ''
    };
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error:', error);
    alert('Error loading product');
    router.push('/admin/products');
  } finally {
    loading.value = false;
  }
};

const handleSubmit = async (event) => {
  event.preventDefault();
  try {
    if (isEditMode.value) {
      await api.put(`/products/${route.params.id}`, formData.value);
      alert('Product updated successfully!');
    } else {
      await api.post('/products', formData.value);
      alert('Product created successfully!');
    }
    router.push('/admin/products');
  } catch (error) {
    alert(error.response?.data?.message || 'Error');
  }
};

const handleCancel = () => {
  router.push('/admin/products');
};

onMounted(() => {
  fetchCategories();
  if (isEditMode.value) {
    fetchProduct();
  } else {
    loading.value = false;
  }
});
</script>

<template>
  <div v-if="loading" class="loading">Loading...</div>
  <div v-else class="admin-products-container">
    <div class="admin-container">
      <div class="admin-header">
        <h1>{{ isEditMode ? 'Edit Product' : 'Add Product' }}</h1>
      </div>

      <form class="form-container" style="max-width: 100%; margin-top: 20px;" @submit="handleSubmit">
        <div class="form-group">
          <label>Name</label>
          <input v-model="formData.name" type="text" required />
        </div>
        <div class="form-group">
          <label>Description</label>
          <input v-model="formData.description" type="text" />
        </div>
        <div class="form-group">
          <label>Price</label>
          <input v-model="formData.price" type="number" step="0.01" required />
        </div>
        <div class="form-group">
          <label>Original Price (for discount)</label>
          <input v-model="formData.original_price" type="number" step="0.01" />
        </div>
        <div class="form-group">
          <label>Category</label>
          <select v-model="formData.category_id" required>
            <option value="">Select a category</option>
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
          </select>
        </div>
        <div class="form-group">
          <label>Image URL</label>
          <input v-model="formData.image_url" type="text" />
        </div>
        <div class="form-group">
          <label>Discount Percentage</label>
          <input v-model="formData.discount_percentage" type="number" />
        </div>
        <div class="form-group">
          <label>Stock</label>
          <input v-model="formData.stock" type="number" />
        </div>
        <div class="form-group">
          <label>Available Colors (comma-separated, e.g., Black,White,Blue)</label>
          <input v-model="formData.available_colors" type="text" placeholder="Black,White,Blue,Red" />
        </div>
        <div class="form-group">
          <label>Available Sizes (comma-separated, e.g., XS,S,M,L,XL or 38,39,40,41,42)</label>
          <input v-model="formData.available_sizes" type="text" placeholder="XS,S,M,L,XL or 38,39,40,41,42" />
        </div>
        <div style="display: flex; gap: 15px;">
          <button type="submit" class="btn-primary">{{ isEditMode ? 'Update' : 'Add' }}</button>
          <button type="button" class="btn-secondary" @click="handleCancel">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>
