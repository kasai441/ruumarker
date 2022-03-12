import axios from 'axios'

const apiUrlBase = '/api/marks'
const headers = { 'Content-Type': 'multipart/form-data'
}
axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
}
const state = {
  posts: []
}

const getters = {
  posts: state => {
    console.log('getters:')
    console.log(state)
    return state.posts.sort((a, b) => b.id - a.id)
  }
}

const mutations = {
  setPosts: (state, posts) => {
    console.log('setPosts:')
    console.log(state)
    console.log(posts)
    return (state.posts = posts)
  },
  appendPost: (state, post) => {
    console.log('appendPosts:')
    console.log(state)
    return (state.posts = [...state.posts, post])
  },
  removePost: (state, id) =>
    (state.posts = state.posts.filter(post => post.id !== id))
}

const actions = {
  async fetchPosts({ commit }) {
    try {
      const response = await axios.get(`${apiUrlBase}`)
      commit('setPosts', response.data)
    } catch (e) {
      console.error(e)
    }
  },
  async createPost({ commit }, post) {
    try {
      const response = await axios.post(`${apiUrlBase}`, post, headers)
      commit('appendPost', response.data)
    } catch (e) {
      console.error(e)
    }
  },
  async deletePost({ commit }, id) {
    try {
      axios.delete(`${apiUrlBase}/${id}`)
      commit('removePost', id)
    } catch (e) {
      console.error(e)
    }
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}
