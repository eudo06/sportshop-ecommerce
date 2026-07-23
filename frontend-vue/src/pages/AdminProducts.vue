<script setup>
import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import api from '@/services/api';
import '@/assets/styles/pages/AdminProducts.css';

const router = useRouter();
const products = ref([]);
const loading = ref(true);

const fetchProducts = async () => {
  try {
    const { data } = await api.get('/products');
    products.value = data;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error:', error);
  } finally {
    loading.value = false;
  }
};

const handleEdit = (productId) => {
  router.push(`/admin/products/${productId}/edit`);
};

const handleDelete = async (id) => {
  if (window.confirm('Are you sure you want to delete this product?')) {
    try {
      await api.delete(`/products/${id}`);
      fetchProducts();
    } catch (error) {
      alert(error.response?.data?.message || 'Error');
    }
  }
};

onMounted(() => {
  fetchProducts();
});
</script>

<template>
  <div v-if="loading" class="loading">Loading...</div>
  <div v-else class="admin-products-container">
    <div class="admin-container">
      <div class="admin-header">
        <h1>Product Management</h1>
        <button type="button" class="btn-primary" @click="router.push('/admin/products/new')">Add Product</button>
      </div>

      <div class="cart-table" style="margin-top: 30px;">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Price</th>
              <th>Category</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in products" :key="product.id">
              <td>{{ product.id }}</td>
              <td>{{ product.name }}</td>
              <td>${{ parseFloat(product.price || 0).toFixed(2) }}</td>
              <td>{{ product.category_name }}</td>
              <td>
                <button type="button" class="btn-secondary" style="margin-right: 10px;" @click="handleEdit(product.id)">
                  Edit
                </button>
                <button type="button" class="btn-danger" @click="handleDelete(product.id)">
                  Delete
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
