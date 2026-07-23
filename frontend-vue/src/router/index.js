import { createRouter, createWebHistory } from 'vue-router';
import Home from '@/pages/Home.vue';
import ProductList from '@/pages/ProductList.vue';
import ProductDetail from '@/pages/ProductDetail.vue';
import Login from '@/pages/Login.vue';
import Register from '@/pages/Register.vue';
import Cart from '@/pages/Cart.vue';
import AdminProducts from '@/pages/AdminProducts.vue';
import AdminProductForm from '@/pages/AdminProductForm.vue';
import AdminUsers from '@/pages/AdminUsers.vue';
import { useAuthStore } from '@/stores/auth';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'home', component: Home },
    { path: '/products', name: 'products', component: ProductList },
    { path: '/products/:id', name: 'product-detail', component: ProductDetail },
    { path: '/login', name: 'login', component: Login },
    { path: '/register', name: 'register', component: Register },
    {
      path: '/cart',
      name: 'cart',
      component: Cart,
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/products',
      name: 'admin-products',
      component: AdminProducts,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/products/new',
      name: 'admin-products-new',
      component: AdminProductForm,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/products/:id/edit',
      name: 'admin-products-edit',
      component: AdminProductForm,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/users',
      name: 'admin-users',
      component: AdminUsers,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    { path: '/:pathMatch(.*)*', redirect: '/' }
  ]
});

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore();

  if (!authStore.initialized) {
    await authStore.initialize();
  }

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    return next({ path: '/login', query: { redirect: to.fullPath } });
  }

  if (to.meta.requiresAdmin && !authStore.isAdmin) {
    return next('/');
  }

  if ((to.name === 'login' || to.name === 'register') && authStore.isAuthenticated) {
    return next('/');
  }

  return next();
});

export default router;
