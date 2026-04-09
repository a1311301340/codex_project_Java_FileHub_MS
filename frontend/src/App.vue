<script setup lang="ts">
import axios from 'axios';
import { onMounted, ref } from 'vue';

type HealthResponse = {
  success: boolean;
  message: string;
  data?: {
    service: string;
    status: string;
    timestamp: string;
  };
};

const health = ref<HealthResponse | null>(null);
const loading = ref(false);
const error = ref('');

const fetchHealth = async () => {
  loading.value = true;
  error.value = '';
  try {
    const { data } = await axios.get<HealthResponse>('/api/health');
    health.value = data;
  } catch (e: any) {
    error.value = e?.message ?? 'request failed';
  } finally {
    loading.value = false;
  }
};

onMounted(fetchHealth);
</script>

<template>
  <main class="app-shell">
    <section class="hero">
      <h1>FileHub 文件分类管理系统</h1>
      <p>工程化基础架构已就绪：Spring Boot + Vue + Electron + MySQL + Redis。</p>
      <button @click="fetchHealth" :disabled="loading">
        {{ loading ? 'Checking...' : '检查后端健康状态' }}
      </button>
      <p v-if="error" class="error">{{ error }}</p>
      <pre v-if="health">{{ health }}</pre>
    </section>
  </main>
</template>
