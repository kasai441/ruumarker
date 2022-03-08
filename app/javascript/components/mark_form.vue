<template>
  <div>
    <h2>MarkForm</h2>
    <div>{{ roomId }}</div>
    <section>
      <label for="description">description: </label>
      <input type="text" name="description" v-model="description" placeholder="description" />
    </section>
    <section>
      <label for="location">location: </label>
      <input type="text" name="location" v-model="location" placeholder="location" />
    </section>
    <section>
      <label for="image">image: </label>
      <input type="file" id="image" name="image" accept="image/png,image/jpeg" @change="setImage" />
    </section>
    <section>
      <button type="submit" @click="upload" :disabled="description === ''">upload</button>
    </section>
  </div>
</template>

<script>
import { mapActions } from "vuex";

export default {
  name: "MarkForm",
  inject: ['roomId'],
  data() {
    return {
      roomId: this.roomId,
      description: "",
      location: "",
      image: "",
      imageFile: null
    }
  },
  methods: {
    ...mapActions("posts", ["createPost"]),
    setImage(e) {
      e.preventDefault();
      this.imageFile = e.target.files[0];
    },
    async upload() {
      console.log(this.roomId);
      console.log(this.description);
      let formData = new FormData();
      formData.append("room_id", this.roomId);
      formData.append("mark[description]", this.description);
      formData.append("mark[location]", this.location);
      if (this.imageFile !== null) {
        formData.append("mark[image]", this.imageFile);
      }
      this.createPost(formData);
      this.resetForm();
    },
    resetForm() {
      this.description = "";
      this.imageFile = null;
    }
  }
};
</script>
