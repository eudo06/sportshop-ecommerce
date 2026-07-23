import { defineStore } from 'pinia';
import api from '@/services/api';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    token: localStorage.getItem('token'),
    loading: false,
    initialized: false
  }),
  getters: {
    isAuthenticated: (state) => !!state.user,
    isAdmin: (state) => state.user?.role === 'admin'
  },
  actions: {
    async initialize() {
      if (this.initialized) return;
      this.loading = true;

      if (this.token) {
        api.defaults.headers.common.Authorization = `Bearer ${this.token}`;
        await this.fetchProfile();
      }

      this.loading = false;
      this.initialized = true;
    },
    async fetchProfile() {
      try {
        const { data } = await api.get('/auth/profile');
        this.user = data;
      } catch (error) {
        this.logout();
      }
    },
    async login(email, password) {
      this.loading = true;
      try {
        const { data } = await api.post('/auth/login', { email, password });
        this.token = data.token;
        this.user = data.user;
        localStorage.setItem('token', data.token);
        api.defaults.headers.common.Authorization = `Bearer ${data.token}`;
        return { success: true };
      } catch (error) {
        return {
          success: false,
          message: error.response?.data?.message || 'Login error'
        };
      } finally {
        this.loading = false;
      }
    },
    async register(nickname, email, password) {
      this.loading = true;
      try {
        const { data } = await api.post('/auth/register', { nickname, email, password });
        this.token = data.token;
        this.user = data.user;
        localStorage.setItem('token', data.token);
        api.defaults.headers.common.Authorization = `Bearer ${data.token}`;
        return { success: true };
      } catch (error) {
        return {
          success: false,
          message: error.response?.data?.message || 'Registration error'
        };
      } finally {
        this.loading = false;
      }
    },
    logout() {
      this.token = null;
      this.user = null;
      localStorage.removeItem('token');
      delete api.defaults.headers.common.Authorization;
    }
  }
});
