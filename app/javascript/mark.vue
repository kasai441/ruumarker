<template>
  <div id="mark-item">
    <Demo />
    <PostForm />
    <PostList />

    <div>{{ roomId }}</div>
  </div>
</template>

<script>
import PostForm from './components/mark_form.vue'
import PostList from './components/mark_list.vue'
import Demo from './demo.vue'

export default {
  name: 'MarkItem',
  inject: ['roomId'],
  data() {
    return {
      roomId: this.roomId,
      description: '',
      location: '',
      image: '',
      imageFile: null
    }
  },
  provide() {
    return {
      roomId: this.roomId
    }
  },
  components: {
    PostForm,
    PostList,
    Demo
  },
}
</script>
