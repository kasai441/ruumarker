import axios from 'axios'

const x_csrf_token = document.querySelector('meta[name="csrf-token"]')
const headers = {
  headers: {
    'Content-Type': 'multipart/form-data',
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : x_csrf_token ? x_csrf_token.getAttribute('content') : null
  }
}

const actions = {
  async all(url) {
    try {
      const response = await axios.get(url)
      return response.data
    } catch (e) {
      console.error(e)
    }
  },
  async create(url, formData) {
    try {
      const response = await axios.post(url, formData, headers)
      return response.data
    } catch (e) {
      console.error(e)
    }
  },
  async show(url) {
    try {
      // axios.get(`${url}/${id}`)
      axios.get(url)
    } catch (e) {
      console.error(e)
    }
  },
  async delete(url, id) {
    try {
      axios.delete(`${url}/${id}`)
    } catch (e) {
      console.error(e)
    }
  }
}

export default {
  namespaced: true,
  actions
}
