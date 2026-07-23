<script setup>
import { onMounted, ref } from 'vue';
import { RouterLink } from 'vue-router';
import api from '@/services/api';
import ProductCard from '@/components/ProductCard.vue';
import { useAuthStore } from '@/stores/auth';
import '@/assets/styles/pages/Home.css';

const auth = useAuthStore();
const categories = ref([]);
const featuredProducts = ref([]);
const loading = ref(true);

const fetchCategories = async () => {
  try {
    const { data } = await api.get('/categories');
    categories.value = data;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error fetching categories:', error);
  }
};

const fetchFeaturedProducts = async () => {
  try {
    const { data } = await api.get('/products');
    featuredProducts.value = data.slice(0, 6);
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error fetching products:', error);
  } finally {
    loading.value = false;
  }
};

const getCategoryImage = (categoryName) => {
  const categoryImages = {
    Running: 'https://i.pinimg.com/736x/76/8a/b1/768ab14d5fa24a2e8d1b78d12880164d.jpg?w=400&h=400&fit=crop&q=90',
    Fitness: 'https://i.pinimg.com/736x/db/46/7f/db467fe697ce03d79c5b80f44f43ff95.jpg?w=400&h=400&fit=crop&q=90',
    Swimming: 'https://i.pinimg.com/736x/76/c3/12/76c31223133d485f315b44784aa52535.jpg?w=400&h=400&fit=crop&q=90',
    Cycling: 'https://i.pinimg.com/736x/dd/a5/27/dda52796c6b5d7090f3cad1872dc1bbf.jpg?w=400&h=400&fit=crop&q=90',
    Football: 'https://i.pinimg.com/1200x/12/c3/02/12c302fefbc0c278d9dff0dead78be9d.jpg?w=400&h=400&fit=crop&q=90',
    Basketball: 'https://i.pinimg.com/1200x/c4/7d/b4/c47db432df6dcdca1837914171f7f492.jpg?w=400&h=400&fit=crop&q=90',
    Tennis: 'https://i.pinimg.com/736x/f2/be/72/f2be72f9875e4dfe78589f3f90acb094.jpg?w=400&h=400&fit=crop&q=90',
    Hiking: 'https://i.pinimg.com/736x/22/a8/eb/22a8ebe6f7ad4cea9b6311f1388c3112.jpg?w=400&h=400&fit=crop&q=90'
  };
  return categoryImages[categoryName] || 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop&q=90';
};

onMounted(() => {
  fetchCategories();
  fetchFeaturedProducts();
});
</script>

<template>
  <div class="home-container">
    <section class="hero-section">
      <div class="hero-content">
        <h1 class="hero-title">Welcome to SportShop</h1>
        <p class="hero-subtitle">Your one-stop destination for all sports equipment and gear</p>
        <div class="hero-buttons">
          <RouterLink to="/products" class="btn-hero-primary">Shop Now</RouterLink>
          <RouterLink v-if="!auth.isAuthenticated" to="/register" class="btn-hero-secondary">Create Account</RouterLink>
        </div>
      </div>
      <div class="hero-image">
        <div class="hero-overlay"></div>
      </div>
    </section>

    <section class="categories-section">
      <h2 class="section-title">Shop by Category</h2>
      <div class="categories-grid">
        <RouterLink
          v-for="category in categories"
          :key="category.id"
          :to="`/products?category_id=${category.id}`"
          class="category-card"
        >
          <div class="category-image-container">
            <img
              :src="getCategoryImage(category.name)"
              :alt="category.name"
              class="category-image"
            />
          </div>
          <h3>{{ category.name }}</h3>
        </RouterLink>
      </div>
    </section>

    <section class="featured-section">
      <div class="section-header">
        <h2 class="section-title">Featured Products</h2>
        <RouterLink to="/products" class="view-all-link">View All →</RouterLink>
      </div>
      <div v-if="loading" class="loading">Loading products...</div>
      <div v-else class="products-grid">
        <ProductCard v-for="product in featuredProducts" :key="product.id" :product="product" />
      </div>
    </section>

    <section class="promotions-section">
      <div class="promo-banner">
        <div class="promo-content">
          <h2>Special Offers</h2>
          <p>Discover our discounted products with amazing deals</p>
          <RouterLink to="/products?category_id=on_sale" class="btn-promo">Shop Sale</RouterLink>
        </div>
      </div>
    </section>

    <section class="features-section">
      <h2 class="section-title">Why Choose SportShop?</h2>
      <div class="features-grid">
        <div class="feature-item">
          <div class="feature-icon feature-icon-shipping">
            <span class="icon-box"></span>
            <span class="icon-dot"></span>
          </div>
          <h3>Free Shipping</h3>
          <p>Free shipping on orders over $50</p>
        </div>
        <div class="feature-item">
          <div class="feature-icon feature-icon-returns">↻</div>
          <h3>Easy Returns</h3>
          <p>30-day return policy</p>
        </div>
        <div class="feature-item">
          <div class="feature-icon feature-icon-quality">★</div>
          <h3>Quality Guaranteed</h3>
          <p>Premium quality products</p>
        </div>
        <div class="feature-item">
          <div class="feature-icon feature-icon-payment">
            <span class="icon-lock"></span>
          </div>
          <h3>Secure Payment</h3>
          <p>Safe and secure checkout</p>
        </div>
      </div>
    </section>

    <section v-if="!auth.isAuthenticated" class="cta-section">
      <div class="cta-content">
        <h2>Join Our Community</h2>
        <p>Create an account to enjoy exclusive deals and track your orders</p>
        <div class="cta-buttons">
          <RouterLink to="/register" class="btn-cta-primary">Sign Up Free</RouterLink>
          <RouterLink to="/login" class="btn-cta-secondary">Sign In</RouterLink>
        </div>
      </div>
    </section>
  </div>
</template>
