<script setup>
import { RouterView } from 'vue-router';
import Navbar from '@/components/Navbar.vue';
</script>

<template>
  <div class="App">
    <Navbar />
    <main class="main-content">
      <RouterView />
    </main>
  </div>
</template>
