<template>
  <div>
    <h1>{{description}}</h1>
    <p><input v-model="description"></p>
    <h1>{{location}}</h1>
    <p><input v-model="location"></p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      description: '',
      location: ''
    };
  }
}
</script>
