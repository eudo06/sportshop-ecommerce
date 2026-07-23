<script setup>
import { onMounted, ref } from 'vue';
import api from '@/services/api';
import '@/assets/styles/pages/AdminUsers.css';

const users = ref([]);
const loading = ref(true);

const fetchUsers = async () => {
  try {
    const { data } = await api.get('/users');
    users.value = data;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error:', error);
  } finally {
    loading.value = false;
  }
};

const handleBan = async (userId, isBanned) => {
  try {
    if (isBanned) {
      await api.post(`/users/${userId}/unban`);
    } else {
      await api.post(`/users/${userId}/ban`);
    }
    fetchUsers();
  } catch (error) {
    alert(error.response?.data?.message || 'Error');
  }
};

onMounted(() => {
  fetchUsers();
});
</script>

<template>
  <div v-if="loading" class="loading">Loading...</div>
  <div v-else class="admin-users-container">
    <div class="admin-container">
      <div class="admin-header">
        <h1>User Management</h1>
      </div>

      <div class="cart-table" style="margin-top: 30px;">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Nickname</th>
              <th>Email</th>
              <th>Role</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.id">
              <td>{{ user.id }}</td>
              <td>{{ user.nickname }}</td>
              <td>{{ user.email }}</td>
              <td>{{ user.role }}</td>
              <td>
                <span
                  v-if="user.is_banned"
                  style="color: #ef4444; font-weight: bold; padding: 6px 12px; border-radius: 8px; display: inline-block; background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3);"
                >
                  Banned
                </span>
                <span
                  v-else
                  style="color: #10b981; font-weight: bold; padding: 6px 12px; border-radius: 8px; display: inline-block; background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.3);"
                >
                  Active
                </span>
              </td>
              <td>
                <button
                  v-if="user.role !== 'admin'"
                  :class="user.is_banned ? 'btn-success' : 'btn-danger'"
                  type="button"
                  @click="handleBan(user.id, user.is_banned)"
                >
                  {{ user.is_banned ? 'Unban' : 'Ban' }}
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
